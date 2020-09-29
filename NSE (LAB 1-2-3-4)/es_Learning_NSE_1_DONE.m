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
do_sliding_window = true; % forces the classifier to be updated over the latest sliding_window_training samples 
sliding_window_training = 50; % just for sliding window classifier
      
% switch between NN and KNN
do_use_knn = true;

%% generate dataset
% refer to defineExperimentParameters for details about testID
testID = 211;

N = 2000; % dataset length
m = 1; % rate of supervised samples: one sample out of m is supervised, the higher, the fewer supervised samples provided

% generate synthetic dataset
[DataSet, Labels, ConceptLengths] = f_createDatasetDrift(testID, N, m);
l_temp =  unique(Labels);
label1 = l_temp(1);
label2 = l_temp(2);

% visualize Dataset
plotDataSet(DataSet, Labels, ConceptLengths, figureNumber)

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
   % KNN, fixed K
    if do_sliding_window
        K_value = round(sqrt(sliding_window_training));
    else
        K_value = round(sqrt(TR_SIZE));
    end
    knnClassifier = fitcknn(TR_data', TR_labels', 'NumNeighbors', K_value);
else
    NET_PARAMS = [15, 10, 5];
    net = patternnet(NET_PARAMS);
    net.trainParam.showWindow = false;
    net = train(net, TR_data, TR_labels);
end

%% inizialize vectors for classification output and for detection outcomes
y_hat = nan(size(Labels));
y_hat(1 : TR_SIZE) = Labels(1 : TR_SIZE);
conceptStartsAt = [1];   % this vector indicates when each new concept starts
current_TR_indexes = []; % this vector contains the training set indexes for updating (or training) the classifier
                         % when this is empty, the classifier is updated from all the supervised samples observed
                         % from current_TR_indexes(end) till the latest stample

%% analyze the stream
for ii = TR_SIZE + 1 : N
        
    %% Classify the received input samples (very ineffcient!)
    if do_use_knn
        y_hat(ii) = knnClassifier.predict(DataSet(:,  ii)');
    else
        [posterior] = net(DataSet(:,  ii));
        y_hat(ii) = posterior > 0.5;
    end
    
    %% Update the classifier using an adaptively identified training set
    % if the sample is supervised, update the classifier (after having performed prediction)
    if supervisedMask(ii) && do_update
        % update the classifier provided new supervised information
        
        % update the classifier, by gathering all the samples from the concept start till now
        current_TR_indexes = supervisedIndexes(conceptStartsAt+1:ii) ;

        if do_sliding_window
            % update the classifier, by gathering the latest \nu supervised samples
            current_TR_indexes = supervisedIndexes(ii - sliding_window_training : ii);
        end
        
        % update the classifier
        if do_use_knn
            % possibly update K as the training set size increases (e.g. sqrt(n))
            K_value=round(sqrt(numel(current_TR_indexes)));
            knnClassifier = fitcknn(DataSet(:, current_TR_indexes)', Labels(current_TR_indexes)', 'NumNeighbors', K_value);
        else
            net = train(net, DataSet(:, current_TR_indexes), Labels(current_TR_indexes));
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
errors(1 : TR_SIZE) = 0; % set classification error to 0 over training set
averagedClassificationErrorStationary = convn(errors, ones(1, smoothing_window_error) / smoothing_window_error);
figure(125),
plot(averagedClassificationError, 'b-', 'LineWidth', 3);
hold on
plot(averagedClassificationErrorStationary, 'r-', 'LineWidth', 3);
hold off
legend('adaptive', 'non-adaptive')
title('Classification Error')
set(gca, 'FontSize', FNT_SZ)
saveas(gcf, 'ErrorAdaptive.png')

