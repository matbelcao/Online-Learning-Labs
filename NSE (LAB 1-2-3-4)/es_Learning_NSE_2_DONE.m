% Online Learning And Monitoring
% Giacomo Boracchi
% May 2020
%
% Politecnico di Milano
% giacomo.boracchi@polimi.it
%
close all
clear
clc

addpath('SyntheticDatasets/')

% visualization paramters
do_show = 1;
figureNumber = 123;
FNT_SZ = 18;

% define monitoring and update modality
do_update = true; % updates the classifier 
do_sliding_window = false; % forces the classifier to be updated over the latest sliding_window_training samples 
do_monitor_err = true;
do_monitor_x = false;

sliding_window_training = 50; % just for sliding window classifier
      
% switch between NN and KNN
do_use_neuralNet = false;

%% generate dataset
% refer to defineExperimentParameters for details about testID
if do_monitor_x
    testID = 212; 
else
    testID = 211;
end

N = 2000; % dataset length
m = 1; % rate of supervised samples: one sample out of m is supervised, the higher, the fewer supervised samples provided

% generate synthetic dataset
[DataSet, Labels, ConceptLengths] = f_createDatasetDrift(testID, N, m);
l_temp =  unique(Labels);
label1 = l_temp(1);
label2 = l_temp(2);

% visualize Dataset
plotDataSet(DataSet, Labels, ConceptLengths, figureNumber)
% set(gca, 'FontSize', FNT_SZ)
% saveas(gcf, 'DatasetConceptDrift.png')

% Define Training Set
TR_SIZE = ConceptLengths(1) / 2;
TR_data = DataSet(:, 1 : TR_SIZE);
TR_labels = Labels(1, 1 : TR_SIZE);

% Define supervised information that will be provided over the whole datastream
supervisedIndexes = [1 : TR_SIZE, TR_SIZE + m : m : N]; % feedback that will be provided
supervisedMask = false(size(supervisedIndexes)); % just for convenience store a binary mask supervised/not supervised
supervisedMask(supervisedIndexes) = true;

%% Training The Classifier over the initial concept

% train your favourite classifier (watch out to arrange input as requested by these functions).
if do_use_neuralNet
    % Neural Network
    NET_PARAMS = [15, 10, 5];
    net = patternnet(NET_PARAMS);
    net.trainParam.showWindow = false;
    net = train(net, TR_data, TR_labels);
else
    % KNN, fixed K
    K_value = round(sqrt(TR_SIZE));
    knnClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value);
end

%% Define and initialize the parameters for the EWMA control chart
% See   
%   Gordon J. Ross, Niall M. Adams, Dimitris K. Tasoulis, David J. Hand
%   Exponentially weighted moving average charts for detecting concept drift
%   Pattern Recognition Letters 2012

lambda = 0.2; % minimum window size where to compute the classification error

% function for defining the threshold and preserve the ARL0 of the test
% L_funct = @(p0)((2.76 - 6.23*p0 + 18.12*p0.^3 - 312.45*p0.^5 + 1002.18*p0.^7)); %function returning threhsolds ARL0 = 100
L_funct = @(p0)((3.97 - 6.56*p0 + 48.73*p0.^3 - 330.13*p0.^5 + 848.18*p0.^7)); %function returning threhsolds ARL0 = 400
% L_funct = @(p0)((1.17 - 7.56*p0 + 21.24*p0.^3 - 112.12*p0.^5 + 987.23*p0.^7)); %function returning threhsolds ARL0 = 1000 % Check this latter as in the paper is negative!

Z = 0; % EWMA statistic 
Z_vect = nan(size(Labels)); % (store all the values in a vector for visualization purposes
Z_vect(1 : TR_SIZE + 1) = 0;

p0 = 0; % estimated error probability using uniform weights
p0_vect = nan(size(Labels)); % vector 
p0_vect(1 : TR_SIZE + 1) = p0;

E_vect = nan(size(Labels)); % vector of errors
E_vect(1 : TR_SIZE + 1) = 0;

t = 0; % number of supervised samples being averaged
threshold_vect(1 : TR_SIZE + 1) = 0;

warning_level = 0;

%% inizialize vectors for classification output and for detection outcomes
y_hat = nan(size(Labels));
y_hat(1 : TR_SIZE) = Labels(1 : TR_SIZE);
conceptStartsAt = [1];   % this vector indicates when each new concept starts
current_TR_indexes = []; % these vector contains the training set indexes for updating (or training) the classifier
                         % when this is empty, the classifier is updated from all the supervised samples observed
                         % from current_TR_indexes(end) till the latest stample

%% analyze the stream
for ii = TR_SIZE + 1 : N
        
    %% 1) classify the received input samples (very ineffcient!)
    if do_use_neuralNet
        [posterior] = net(DataSet(:,  ii));
        % populate the vector or predictions
        y_hat(ii) = posterior > 0.5;
    else
        y_hat(ii) = knnClassifier.predict(DataSet(:,  ii)');
    end

    %% 2) Post-classification analysis,
    
    if supervisedMask(ii)
        t = t + 1; % count how many supervised samples have been received so far
    end
    
    %% 3.1) Monitor the classification error
    if supervisedMask(ii) && do_monitor_err 
       
        % compute the value of the Bernoulli distribution (correct=0/wrong prediction=1)
        % E = 
        E = y_hat(ii) ~= Labels(ii);
        E_vect(ii) = E;
        
        % estimate the probability of error (this is \hat{p}_{0,t} in [1]
        % p0 = 
        p0 = p0 * (t / (t+1)) + E /(t+1);
        p0_vect(ii) = p0;
        
        % VARIANCE of Bernoulli distribution
        % var0 = 
        var0 = p0 * (1 - p0); 

        % compute EWMA statistics
        % Z = 
        Z = (1 - lambda) * Z + lambda * E;
        Z_vect(ii) = Z;
        
        % STD of the EWMA statistics
        % stdZ = 
        std0 = sqrt(var0);
        stdZ = std0 * sqrt( (lambda / (2 - lambda)) * (1 - (1 - lambda)^(2 * t)));
        
        % compute the thredhold by the provided function
        % Lt = 
        % threshold_vect(ii) =
        Lt = L_funct(p0);
        threshold_vect(ii) = p0 + Lt * stdZ;
        
        % CHECK for warning level
        if Z > p0 + 0.5 * Lt * stdZ  % ENTER HERE THE CONDITION INSTEAD
            % store the point where the control-chart limit has been exceeded
            if warning_level == 0
                warning_at = ii;
                warning_level = 1;
            end
        else
            warning_level = 0; % cancel the warning if the stat drops below the level
        end
        
        % CHECK detection Level
        if Z > p0 + Lt * stdZ % ENTER HERE THE CONDITION INSTEAD
            % define new training set 
            % current_TR_indexes = 
            current_TR_indexes = supervisedIndexes(warning_at : ii);
            conceptStartsAt = [conceptStartsAt, warning_at];
            %startingPointForComputingError = [startingPointForComputingError, warning_at];
             
            % reset EWMA statistics (reset all the parameters involved!)
            p0 = 0;
            Z = 0;
            t = 0;
            
            % reset the classifier (check whether this is needed for your favourite classifier
            if do_use_neuralNet
                net = patternnet([15, 10, 5]);
                net.trainParam.showWindow = false;
            end
            
            fprintf('\nchange detected at %d, concept started at %d', ii, conceptStartsAt(end));
        end
    end
    
    %% 3.2) Update the classifier using an adaptively identified training set
    % if the sample is supervised, update the classifier (after having performed prediction)
    if supervisedMask(ii) && do_update
        % update the classifier provided new supervised information
        if isempty(current_TR_indexes)
            % update the classifier, by gathering all the samples from the concept start till now
            current_TR_indexes = supervisedIndexes(supervisedIndexes >= conceptStartsAt(end) & supervisedIndexes <= ii);
        end

        if do_sliding_window
            % update the classifier, by gathering the latest \nu supervised samples
            current_TR_indexes = supervisedIndexes(ii - sliding_window_training : ii);
        end

        % update the classifier
        if do_use_neuralNet
            net = train(net, DataSet(:, current_TR_indexes), Labels(current_TR_indexes));
        else
            % possibly update K as the training set size increases (e.g. sqrt(n))
            knnClassifier = fitcknn(DataSet(:, current_TR_indexes)', Labels(current_TR_indexes)', 'NumNeighbors', K_value);
        end
    
        % if there is no change, the classifier will define the training set as the whole concept observed so far
        current_TR_indexes = [];
    end
end

%% display the classification error and compute that with a stationary classifier
% compute classification error
fprintf('\ndone\n')
smoothing_window_error = 50;
errors = y_hat ~= Labels;

% nu batch where to compute average error
averagedClassificationError = convn(errors, ones(1, smoothing_window_error) / smoothing_window_error);

%% non adaptive classifier

if do_use_neuralNet
    net = patternnet(NET_PARAMS);
    net.trainParam.showWindow = false;
    net = train(net, TR_data, TR_labels);
    pst = net(DataSet);
    y_hat_stationary = pst > 0.5;
else
    knnClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value);
    y_hat_stationary = knnClassifier.predict(DataSet');
    y_hat_stationary = y_hat_stationary';
end

errors = y_hat_stationary ~= Labels;
errors(1 : TR_SIZE) = 0;
averagedClassificationErrorStationary = convn(errors, ones(1, smoothing_window_error) / smoothing_window_error);
figure(125),
plot(averagedClassificationError, 'b-', 'LineWidth', 2);
hold on
plot(averagedClassificationErrorStationary, 'r-', 'LineWidth', 2);
hold off
legend('adaptive', 'non-adaptive')
title('Classification Error')
set(gca, 'FontSize', FNT_SZ)


%% DISPLAY THE Z STAT AND THE CONTROL CHART
if do_monitor_err
    figure(234),
    plot(Z_vect, 'LineWidth', 2);
    hold on
    plot(p0_vect, 'LineWidth', 2);
    plot(threshold_vect, 'LineWidth', 2);
    hold off
    legend('EWMA Stat', 'P0 est', 'Threshold')
    title('EWMA statistics and thresholds')
    set(gca, 'FontSize', FNT_SZ)
    saveas(gcf, 'EWMAstatistics.png')
end