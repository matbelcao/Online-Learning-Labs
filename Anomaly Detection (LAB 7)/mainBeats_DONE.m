% Online Learning And Monitoring
% Anomaly Detection
%
% Giacomo Boracchi
% June 2020
%
% Politecnico di Milano
% giacomo.boracchi@polimi.it

close all
clear
clc

% folderName = 'C:\Users\Giacomo Boracchi\Dropbox (DEIB)\Didattica\beats\s20273\';

folderName = './';

% folder where to save output images
imgFolder = 'results/';

% visualization parameters
LN_WDT = 3;
FNT_SZ = 20;

%% Load normal and anomalous heartbeats
% load anomalies and cut them to the target heart-rate (bpm)
temp = load([folderName, 'all_anom_beats.mat']);

% heartreat where to take normal heartbeats
hr = 70; % expressed in bpm

% align anomalous heartbeat by resampling to be comparable with the normal ones
anomalies = cut_signal(temp.anom_beats,50,hr,250);

% load normal heartbeats at hr 
temp = load([folderName, 'hr_', num2str(hr),'.mat']);
normal = temp.normal_beats;

%% Define training and test set
% set the size of the training set containing normal heatbeats (HB)
TR_SIZE = 500;

% define training and test set (test set is provided with annotated anomalies for performance assessment)
TR = normal(:, 1 : TR_SIZE);

% test set is annotated, and contains both normal and anomalous heartbeats
TS = [normal(:, TR_SIZE + 1 : end)];
TS_labels = zeros(1, size(TS, 2));
TS = [TS, anomalies];
TS_labels = [TS_labels, ones(1, size(anomalies, 2))];

%% visualize normal and anomalous beats

for ii = 1 : 150 : size(anomalies, 2)
    figure(1),
    plot(anomalies(:, ii), 'r-', 'LineWidth', LN_WDT),
    title(['anomalous beat nr ', num2str(ii)])
    set(gcf, 'Position', get(0, 'ScreenSize'));
    saveas(gcf, [imgFolder, 'anomalous_', num2str(ii),'.png'])
end

for ii = round(linspace(1, size(TS, 2) / 2, 5))
    figure(1),
    plot(TS(:, ii), 'b-', 'LineWidth', LN_WDT),
    title(['normal beat nr ', num2str(ii)])
    set(gcf, 'Position', get(0, 'ScreenSize'));
    saveas(gcf, [imgFolder, 'normal_', num2str(ii),'.png'])
end

%% now, we have to move to row-wise vector representation, as this is requested by pca function in Matlba
TR = TR';
TS = TS';
TS_labels = TS_labels';

%% learn a model describing normal data
% estimate the mean over the training set to be subtracted form test data
% meanTR = mean(TR);
% TR0 =  
meanTR = mean(TR);
TR0 = TR - meanTR;  

% compute the PCA transformation matrix (this is an orthogonal matrix d x d
[coeff, score, latent, ~, explained] = pca(TR0);

% coeff is the trasformation (orthogonal) matrix:
%       this is what we are interested in
%       we should however cut a few relevant principal components 
%       (otherwise we obtain perfect reconstruction)


% how to define the number of PC to preserve?
% look at the variance explained by each PC components
% the variance explained by each PC is in the latent vector

% define how many PC to preseve in the projection (otherwise you should get perfect reconstruction)
figure(1),
plot(latent, 'LineWidth', LN_WDT)
xlabel('principal component index');
ylabel('variance explained');
title('variance explained')
set(gca, 'FontSize', FNT_SZ);
set(gcf, 'Position', get(0, 'ScreenSize'));
grid on
saveas(gcf, [imgFolder, 'variances_explained.png'])

% select the first m PCs covering 95% of the total variance (check how it works when changing this porpotion)
% m = 
sum_explained = 0;
m = 0;
while sum_explained < 95
    m = m + 1;
    sum_explained = sum_explained + explained(m);
end

% define the projection matrix as the first m principal components (columns of PCA matrix coeff)
% P = 
P = coeff(:,1:m);

%% project the test set over the subspace of the first m PCs
% subtract the mean as in the training set
% TS0 = 
TS0 = TS - meanTR;

% compute the projection of each heartbeat in the m-dimensional PC space, i.e. as a vector of R^m
% X =  % now, each signal is represented by its m projection coefficients
X = TS0 * P;

% reconstruct the signal to go back in the signal domain R^d
% TS_hat0 = 
TS_hat0 = X * P';

%% assess compare signals and their reconstruction after projection
indx = 22750;

if TS_labels(indx)
    col_string = 'r';
else
    col_string = 'b';
end

% compute the reconstruction error which will be used as an anomaly score
% err = 
err = sqrt(sum((TS0(indx)-TS_hat0(indx)).^2,2));

% plot the input signal against the reconstructed signal
figure(1)
% plot(..) original
plot(TS(indx,:), 'b-');
hold on
% plot(..) reconstructed
plot(TS_hat0(indx,:)+meanTR ,'r-');
title(['anomalous: ', num2str(TS_labels(indx)), ' reconstr. error: ', sprintf('%.2f', err)])
hold off
legend('original', 'afer projection over normal subspace')
set(gca, 'FontSize', FNT_SZ);
set(gcf, 'Position', get(0, 'ScreenSize'));
saveas(gcf, [imgFolder, 'normal_anomalous_comparison', num2str(indx),'.png'])

%% check separability by monitoring reconstruction error

% compute the error over the whole TS
% E =
E = sqrt(sum((TS0-TS_hat0).^2,2));

% divide error over normal and anomalous heartbeats
err_normal = E(find(TS_labels == 0));
err_anomal = E(find(TS_labels == 1));

% plot the histograms of the distributions
n_normal = sum(TS_labels == 0);
n_anomal = sum(TS_labels == 1);

[h_normal, c_normal] = hist(err_normal, sqrt(n_normal));
[h_anomal, c_anomal] = hist(err_anomal, sqrt(n_anomal));

% make histogram to unit area
h_normal = h_normal / trapz(c_normal, h_normal);
h_anomal = h_anomal / trapz(c_anomal, h_anomal);

figure(3),
stairs(c_normal, h_normal, 'b', 'LineWidth', LN_WDT);
hold on
stairs(c_anomal, h_anomal, 'r', 'LineWidth', LN_WDT);
hold off
legend('err on normal', 'err on anomalous')
xlabel('err')
grid on
title('empirical distributions of err')
set(gca, 'FontSize', FNT_SZ);
set(gcf, 'Position', get(0, 'ScreenSize'));
saveas(gcf, [imgFolder, 'empirical_distributions.png'])


%% compute performance anomaly detection, namely the AUC curve

% perfcurve computation
[xx,yy,t,AUC] = perfcurve(TS_labels,E,1);

figure(13)
plot(xx, yy, 'm-', 'LineWidth', LN_WDT);
hold on
vv = round(numel(t) * 2.^[-5 : 0.25 : 0]);
for ii = vv
    text(xx(ii), yy(ii), sprintf('%.2f',t(ii)), 'FontSize', 14);
    plot(xx(ii), yy(ii), 'kx', 'MarkerSize', 10, 'LineWidth', LN_WDT);
end
hold off
axis equal
axis tight
grid on
grid minor

xlabel('FPR')
ylabel('TPR')
title(['ROC curve, AUC = ', num2str(AUC)])
set(gca, 'FontSize', FNT_SZ);
set(gcf, 'Position', get(0, 'ScreenSize'));
saveas(gcf, [imgFolder, 'ROC.png'])

