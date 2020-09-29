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
do_monitor_x = true;

sliding_window_training = 50; % just for sliding window classifier
      
% switch between NN and KNN
do_use_knn = true;
NET_PARAMS = [15, 10, 5];

%% generate dataset
% refer to defineExperimentParameters for details about testID
testID = 212;
% TODO: try using different types of changes, possibly modifying the defineExperimentParameters functions
% what's with some changes and this monitoring scheme?

%loglikelihood techniques monitors the raw input distribution. 

%testID=211 --> it is a class swap whithout modyfying the raw input
%distibution, so the loglikelihood isn't able to identify the swap. The
%problem is reduced to an "online" learner without any CDT method, the only
%possibility of adaptation is to have an outlier in the distribution which
%triggers the starting of a new concept. In this case a higher alpha value
%can help to detect some "false-positive" points (from the raw distribution
%perspective) and starting the new concept.

%testID=212 --> in defineExperimentParameters.m this function is a drift
%with a change of the mu ranges of the classes C0 and C1. The loglikelihood is
%able to detect this raw distibution change and so is able to detect the
%starting of a new concept. In this case a lower alpha is better

%N --> increase the number of points,it can help to detect a charnge in the raw distribution 
%m --> it's only useful to train the classifier with more supervised samples, but doesn't
%help the drift detection using the log-likelihood
%alpha --> RULE: decrease alpha implies less false detections (good) 

%how to detect drift of a class swap??? --> change mu or sigma after  (ex testID=2111)


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
if do_use_knn
    % KNN, fixed K
    K_value = round(sqrt(TR_SIZE));
    knnClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value);
else
    net = patternnet(NET_PARAMS);
    net.trainParam.showWindow = false;
    net = train(net, TR_data, TR_labels);
end

%% fit a Gaussian Mixture model for the initial distribution of the data

window_size = 50; % size of the window where to run a t-test on the log-likelihood
TR_fit_size = 300; % size of the trainig set to fit the denisty model

N_GAUSS = 1;
% fit a Gaussian Distribution over the first TR_fit_size samples of TR, namely TR_data(:, 1 : TR_fit_size)
%GMModel = fitgmdist(TR_data(:, 1 : TR_fit_size)',2);
mu = mean(TR_data(:, 1 : TR_fit_size).');
sigma = cov(TR_data(:, 1 : TR_fit_size).');

% define the log-likelihood function [x \to - log(\phi(x))] for a single Gaussian
LL =  @(x)(-log(mvnpdf(x.',mu,sigma)));

alpha = 0.01; % parameter of the T-test

% take part of stationary data not used for training for estimating distribution of log-likelihood values
x_TR = TR_data(:, TR_fit_size + 1 : end); 

% compute the value of the log-likelihood function over stationary data
LL_TR = LL(x_TR);

%% inizialize vectors for classification output and for detection outcomes
y_hat = nan(size(Labels));
y_hat(1 : TR_SIZE) = Labels(1 : TR_SIZE);

%errore??? conceptStartsAt = [1]; 
conceptStartsAt = [TR_fit_size];   % this vector indicates when each new concept starts
current_TR_indexes = []; % these vector contains the training set indexes for updating (or training) the classifier
                         % when this is empty, the classifier is updated from all the supervised samples observed
                         % from current_TR_indexes(end) till the latest stample

% we use this vector to stack all the log-likelihood values                         
LL_ALL = [zeros(1, TR_fit_size), LL_TR'];
%% analyze the stream
for ii = TR_SIZE + 1 : N
    
    %% 1) classify the received input samples (very ineffcient!)
    if do_use_knn
        y_hat(ii) = knnClassifier.predict(DataSet(:,  ii)');
    else
        [posterior] = net(DataSet(:,  ii));
        y_hat(ii) = posterior > 0.5;
    end
    
    %% 2) Monitor Raw input distribution (at each chunk)
    if do_monitor_x && mod(ii - TR_SIZE, window_size) == 0
        
        % crop a window over recent part of the DataSet to compute the log-likelihood
        x_TE = DataSet(:, ii-window_size+1 : ii);

        % compute the log likelihood
        LL_TE = LL(x_TE);
        
        % append the log-likelihood after the change
        LL_ALL = [LL_ALL, LL_TE'];

        % perform a two-sample t-test to detect decrease in the log-likelihood
        h = ttest2(LL_ALL(conceptStartsAt(end) :ii-window_size)',LL_TE,'Alpha',alpha);
        
        if h
            
            % take the last window as a training set for the classifier
            warning_at = ii - window_size;
            current_TR_indexes = supervisedIndexes(warning_at : ii);
            conceptStartsAt = [conceptStartsAt, warning_at];
            
            % reset the classifier
            if not(do_use_knn)
                net = patternnet([15, 10, 5]);
                net.trainParam.showWindow = false;
            end
            
            % after the change, 
            % update the density model by computing the new parameters 
            % define the likelihood function
            
            x_TR = DataSet(:, current_TR_indexes); 
            mu = mean(x_TR.');
            sigma = cov(x_TR.');
            
            LL_TR = LL(x_TE(:, window_size / 2 + 1 : end)); % new function for the log-likelihood
            fprintf('\nchange detected at %d, concept started at %d', ii, conceptStartsAt(end));
            
        end
    end

    %% 3) Update the classifier using an adaptively identified training set
    % if the sample is supervised, update the classifier (after having performed prediction)
    if supervisedMask(ii) && do_update
        % update the classifier provided new supervised information
        if isempty(current_TR_indexes)
            % update the classifier, by gathering all the samples from the concept start till now
            current_TR_indexes = supervisedIndexes(supervisedIndexes >= conceptStartsAt(end) & supervisedIndexes <= ii);
        end

        if do_sliding_window
            % update the classifier, by gathering the latest \nu supervised samples
            current_TR_indexes = supervisedIndexes(supervisedIndexes >= ii-sliding_window_training & supervisedIndexes <= ii);
        end

        % update the classifier
        if do_use_knn
            % possibly update K as the training set size increases (e.g. sqrt(n))
            K_value=round(sqrt(numel(current_TR_indexes)));
            knnClassifier = fitcknn(DataSet(:, current_TR_indexes)', Labels(current_TR_indexes)', 'NumNeighbors', K_value);
        else
            net = train(net, DataSet(:, current_TR_indexes), Labels(current_TR_indexes));
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

if do_use_knn
    K_value = round(sqrt(TR_SIZE));
    knnClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value);
    y_hat_stationary = knnClassifier.predict(DataSet');
    y_hat_stationary = y_hat_stationary';
else
    net = patternnet(NET_PARAMS);
    net.trainParam.showWindow = false;
    net = train(net, TR_data, TR_labels);
    pst = net(DataSet);
    y_hat_stationary = pst > 0.5;
end

errors = y_hat_stationary ~= Labels;
errors(1 : TR_SIZE) = 0;
averagedClassificationErrorStationary = convn(errors, ones(1, smoothing_window_error) / smoothing_window_error);
figure(125),
plot(averagedClassificationError, 'b-', 'LineWidth', 3);
hold on
plot(averagedClassificationErrorStationary, 'r-', 'LineWidth', 3);
hold off
legend('adaptive', 'non-adaptive')
title('Classification Error')
set(gca, 'FontSize', FNT_SZ)
saveas(gcf, 'ClssificationError.png')
%%
if do_monitor_x
    figure(234),
    %plot(LL_ALL, 'r:', 'LineWidth', 1);
    averageLL = convn(LL_ALL, ones(1, smoothing_window_error) / smoothing_window_error);
    hold on
    plot(averageLL, 'b-','LineWidth', 3);
    hold off
    %legend('Log-likelihood all','averageLL')
    legend('averageLL')
    title('Log-likelihood values')
    set(gca, 'FontSize', FNT_SZ)
    saveas(gcf, 'LL_values.png')
end