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

addpath('./SyntheticDatasets/')

% visualization paramters
do_show = 1;
figureNumber = 123;
FNT_SZ = 18;

% define monitoring and update modalities
do_update = true; % updates the classifier
sliding_window_training = 50; % just for the reactive window classifier
do_paired_classifiers = true;

% switch between NN and KNN
do_use_knn = false;
NET_PARAMS = [15, 10, 5];

%% generate dataset
% refer to defineExperimentParameters for details about testID
testID = 204;

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
TR_SIZE = ConceptLengths(1) / 4;
TR_data = DataSet(:, 1 : TR_SIZE);
TR_labels = Labels(1, 1 : TR_SIZE);

% Define supervised information that will be provided over the whole datastream
supervisedIndexes = [1 : TR_SIZE, TR_SIZE + m : m : N]; % feedback that will be provided
supervisedMask = false(size(supervisedIndexes)); % just for convenience store a binary mask supervised/not supervised
supervisedMask(supervisedIndexes) = true;

%% Training The Classifier over the initial concept

if do_use_knn
    % define values of K for the stable and reactive knn
    %K_value_stable =
    %K_win =
    K_value_stable = round(sqrt(TR_SIZE));
    K_win = round(sqrt(sliding_window_training));
    
    % train the stable classifier
    stableClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value_stable);
    
    % define the training set for the window classifier
    TR_win = DataSet(:, 1 : sliding_window_training);
    TR_labels_win = Labels(1, 1 : sliding_window_training);
    
    % train the reactive classifier
    reactiveClassifier = fitcknn(TR_win', TR_labels_win', 'NumNeighbors', K_win);
else
    % train the stable classifier
    netStable = patternnet(NET_PARAMS);
    netStable.trainParam.showWindow = false;
    netStable = train(netStable, TR_data, TR_labels);
    
    % define the training set for the window classifier
    TR_win = DataSet(:, 1 : sliding_window_training);
    TR_labels_win = Labels(1, 1 : sliding_window_training);
    
    % train the stable classifier
    netReactive = patternnet(NET_PARAMS);
    netReactive.trainParam.showWindow = false;
    netReactive = train(netReactive, TR_win, TR_labels_win);
end

%% inizialize vectors for classification output and for detection outcomes
y_hat = nan(size(Labels));
y_hat(1 : TR_SIZE) = Labels(1 : TR_SIZE);
conceptStartsAt = [1];   % this vector indicates when each new concept starts
current_TR_indexes = []; % this vector contains the training set indexes for updating (or training) the classifier
% when this is empty, the classifier is updated from all the supervised samples observed
% from current_TR_indexes(end) till the latest stample
% initialize vectors for classification output of the reactive classifier
% (only for paired classifiers)
y_hat_R = nan(size(Labels));
y_hat_R(1 : TR_SIZE) = Labels(1 : TR_SIZE);

% initialize a FIFO list of elements (out of the most recent window) which is 1 where
% the stable classifier is wrong and the reactive classifier is correct, 0 otherwise
listC = zeros(1,sliding_window_training);

% set an arbitrary threshold for the mean value of listC (makes reactive to replace stable)
theta = 0.2;

%% analyze the stream
for ii = TR_SIZE + 1 : N
    
    %% Classify the received input samples (very inefficient!)
    if do_use_knn
        % compute the output of paired learner system
        y_hat(ii) = stableClassifier.predict(DataSet(:,  ii)');
    else
        [posterior] = netStable(DataSet(:,  ii));
        
        % populate the vector or predictions
        y_hat(ii) = posterior > 0.5;
    end
    
    %% Classify using the reactive classifier and compare performance
    if do_paired_classifiers
        % compute the prediction from the reactive classifier
        if do_use_knn
            % y_hat_R(ii) =
            y_hat_R(ii) = reactiveClassifier.predict(DataSet(:,  ii)');
        else
            [posterior] = netReactive(DataSet(:,  ii));
            
            % populate the vector or predictions
            y_hat_R(ii) = posterior > 0.5;
        end
        
        % update listC as defined in the paper (remember it is a FIFO opened over the latest supervised samples)
        listC(2:end) = listC(1:end-1);
        listC(1)= (y_hat(ii) ~= Labels(ii)) && (y_hat_R(ii) == Labels(ii));
        
        % flag concept drift
        if theta < (sum(listC)/sliding_window_training)
            % replacing S <- R_W can be done by re-defining its training set
            % conceptStartsAt =
            conceptStartsAt = [conceptStartsAt,ii - sliding_window_training];
            
            % if necessary, reset the classifier (e.g. when using a NN)
            if not(do_use_knn)
                netStable = patternnet([15, 10, 5]); % necessary??
                netReactive = patternnet([15, 10, 5]);
                
                netStable.trainParam.showWindow = false; % necessary??
                netReactive.trainParam.showWindow = false;
            end
            
            % reset listC
            % listC =
            listC = zeros(1,sliding_window_training);
            fprintf('\nchange detected at %d, concept started at %d', ii, conceptStartsAt(end));
        end
    end
    
    %% Update the classifier using an adaptively identified training set
    % if the sample is supervised, update the classifier (after having performed prediction)
    if supervisedMask(ii) && do_update
        % update the classifier provided new supervised information
        
        % update the classifier, by gathering all the samples from the concept start till now
        % current_TR_indexes =
        current_TR_indexes = supervisedIndexes(supervisedIndexes >= conceptStartsAt(end) & supervisedIndexes <= ii);
             
        % update the classifiers
        if do_use_knn
            % possibly update K as the training set size increases as sqrt(#TR)
            % K_value_stable = 
            K_value_stable = round(sqrt(numel(current_TR_indexes)));
            
            % update the stable classifier
            stableClassifier = fitcknn(DataSet(:, current_TR_indexes)', Labels(current_TR_indexes)', 'NumNeighbors', K_value_stable);
            
            % update the reactive classifier
            if do_paired_classifiers
                % current_TR_reactive = 
                current_TR_reactive = supervisedIndexes(supervisedIndexes >= ii-sliding_window_training & supervisedIndexes <= ii);
                reactiveClassifier = fitcknn(DataSet(:, current_TR_reactive)', Labels(current_TR_reactive)', 'NumNeighbors', K_win);
            end
        else
            % update the stable classifier
            netStable = train(netStable, DataSet(:, current_TR_indexes), Labels(current_TR_indexes));
            
            % update the reactive classifier
            if do_paired_classifiers
                current_TR_reactive = supervisedIndexes(supervisedIndexes >= ii-sliding_window_training & supervisedIndexes <= ii);
                netReactive = train(netReactive, DataSet(:, current_TR_reactive), Labels(current_TR_reactive));
            end
        end
    end
end

%% display the classification error and compute that with a stationary classifier
% compute classification error
fprintf('\ndone\n')
smoothing_window_error = 100;
errors = y_hat ~= Labels;

% nu batch where to compute average error
averagedClassificationError = convn(errors, ones(1, smoothing_window_error) / smoothing_window_error);

%% non adaptive classifier

if do_use_knn
    K_value = round(sqrt(length(TR_labels)));
    knnClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value);
    y_hat_stationary = knnClassifier.predict(DataSet');
    y_hat_stationary = y_hat_stationary';
else
    netNonAdaptive = patternnet(NET_PARAMS);
    netNonAdaptive.trainParam.showWindow = false;
    
    netNonAdaptive = train(netNonAdaptive, TR_data, TR_labels);
    [posterior] = netNonAdaptive(DataSet);
    
    % populate the vector or predictions
    y_hat_stationary = posterior > 0.5;
end

errorsStationary = y_hat_stationary ~= Labels;
errorsStationary(1 : TR_SIZE) = 0; % set classification error to 0 over training set
averagedClassificationErrorStationary = convn(errorsStationary, ones(1, smoothing_window_error) / smoothing_window_error);
figure(125),
plot(averagedClassificationError, 'b-', 'LineWidth', 3);
hold on
plot(averagedClassificationErrorStationary, 'r-', 'LineWidth', 3);

if do_paired_classifiers
    % compute error for the reactive classifier
    % errors_R = 
    errors_R = y_hat_R ~= Labels;
    
    averagedClassificationError_R = convn(errors_R, ones(1, smoothing_window_error) / smoothing_window_error);

    hold on
    plot(averagedClassificationError_R, 'g-', 'LineWidth', 3);
    hold off
    legend('adaptive', 'non-adaptive', 'reactive')
else
    hold off
    legend('adaptive', 'non-adaptive')
end
title('Classification Error')
set(gca, 'FontSize', FNT_SZ)
saveas(gcf, 'ErrorAdaptive.png')


