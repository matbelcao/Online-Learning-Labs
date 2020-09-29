function [dataSet , labels] = generateMHSequence(N , a , M , m , noise_perc , hyp_center , figureNumber)
%
% function [dataSet , labels] = generateMHSequence(N , a , M , m , noise_perc , figureNumber)
%
%
% N dataset length
% a hyperplane coefficient vector (see below)
% M hypercube where input ranges
% m frequency of supervised samples
% noise_perc percentage in [0,1] of supervised samples where provided class label is wrong
% figureNumber set 0 to show no figure  (optional, default 0);
%
%
% Generate Moving Hyperplane data Sequence
% a(1) è il termine noto dell'equazione
% \sum_i = 1: d  a(i+1) * x(i) + a(1) = 0
% se \sum_i = 1: d  a(i+1) * x(i) + a(1) >= 0 punto sotto l'iperpiano, classe 1
% se \sum_i = 1: d  a(i+1) * x(i) + a(1) < 0 punto sotto l'iperpiano, classe 2
%
% Giacomo Boracchi
% Politecnico di Milano
% giacomo.boracchi@polimi.it
%
% Revision History
% October 2012     - Frist Release

if(~exist('M' , 'var') || isempty(M))
    M = 1;
end

if(~exist('m' , 'var') || isempty(m))
    m = 1;
end

if(~exist('noise_perc' , 'var') || isempty(noise_perc))
    noise_perc = 0;
end

if(~exist('hyp_center' , 'var') || isempty(hyp_center))
    hyp_center = 0;
end

if(~exist('figureNumber' , 'var') || isempty(figureNumber))
    figureNumber = 0;
end

%% generate dataset and class function

if hyp_center == 0
    dataSet = (2 * M * rand(N, length(a) - 1)) - M; %dataset centrato in (0,0) nel ipercubo (-M , M)^n
else
    dataSet = (M * rand(N, length(a) - 1)); % dataset nell'ipercubo [0 , M]^n
end

labels = ones(N ,1);
coeffMatrix = repmat(a(2 : end) , [N , 1]);
labels(sum(coeffMatrix .* dataSet , 2) < -a(1)) = 2;

%% add noise in the class function perc_noise samples of the supervised samples , i.e. 1 every m

indxSwapped  = [];
if noise_perc > 0
    SupervisedSamples = zeros(1 , N);
    SupervisedSamples(m : m : end) = 1;
    supervisedIndex = find(SupervisedSamples);
    nToSwap = length(supervisedIndex) * noise_perc;
    
    indxSwapped = supervisedIndex(randperm(length(supervisedIndex)));
    indxSwapped = indxSwapped(1 : nToSwap);
    
    % swap the classes label
    labels(indxSwapped) = mod(labels(indxSwapped) , 2) + 1;
end

%% show results
if figureNumber > 0
    
    indxClass1 = find(labels == 1);
    indxClass2 = find(labels == 2);
    
    % 1D dataset
    if length(a) == 2
        figure(figureNumber)
        plot(dataSet(indxClass1) , 'bo');
        hold on
        plot(dataSet(indxClass2) , 'rx');
        plot(dataSet(indxSwapped) , 'ro');
        plot(dataSet(indxSwapped) , 'bx');
        hold off
    end
    
    % 2D dataset
    if length(a) == 3
        figure(figureNumber)
        plot(dataSet(indxClass1 , 1) , dataSet(indxClass1 , 2) , 'bo');
        hold on
        plot(dataSet(indxClass2 , 1) , dataSet(indxClass2 , 2) , 'rx');
        plot(dataSet(indxSwapped , 1) , dataSet(indxSwapped , 2) , 'ro');
        plot(dataSet(indxSwapped , 1) , dataSet(indxSwapped , 2) , 'bx');
        hold off
    end
    
    % 3D dataset
    if length(a) == 4
        figure(figureNumber)
        plot3(dataSet(indxClass1 , 1) , dataSet(indxClass1 , 2) , dataSet(indxClass1 , 3) , 'bo');
        hold on
        plot3(dataSet(indxClass2 , 1) , dataSet(indxClass2 , 2) , dataSet(indxClass2 , 3) ,'rx');
        plot3(dataSet(indxSwapped , 1) , dataSet(indxSwapped , 2) , dataSet(indxSwapped , 3) , 'ro');
        plot3(dataSet(indxSwapped , 1) , dataSet(indxSwapped , 2) , dataSet(indxSwapped , 3) , 'bx');
        hold off
    end
    
end