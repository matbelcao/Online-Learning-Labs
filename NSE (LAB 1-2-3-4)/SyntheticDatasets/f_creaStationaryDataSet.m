function [DataSet , Label] = f_creaStationaryDataSet(datasetLength, r, pdf1, pdf2, params1, params2, m, do_shuffle, do_show, label1, label2, figureNumber)
%
% function [DataSet , Label] = f_creaStationaryDataSet(datasetLength, r, pdf1, pdf2, params1, params2, m, do_shuffle, do_show, label1, label2, figureNumber)
%
% Generates a stationary sequence of datasetLength data that can be used both for CDT and Classification purposes.
% Data are i.i.d. drawn from a process having
% two different classes with parametric expression pdf1 e pdf2, and parameters params1 e params2.
% the probability of first class observation is r, and 1-r from the second
% m is the drift coefficients, affecting the expected value of both classes
%
% INPUT
%
% datasetLength     DataSet length
% r                 probability of class1 (1-r) probability of class2
% pdf1, pdf2        pdf of both classess. 'gaussian' , 'poisson' , 'uniform'
% params1, params2  pdf parameters. 
%                   pdf == 'gaussian' params = [mu , sigma]
%                   pdf == 'poisson' params = lambda
%                   pdf == 'uniform' params = [a , b] (distribution interval)
% m                 drift coeffcients. It affects the expected value of X in both classes 
% label1,label2     classes label (optional)
% do_show           (optional)
% do_shuffle         (optional), default == 1, it is necessary only when dataset are created for classification purpose
% figureNumber      (optional)
%
% OUTPUT
%
% DataSet         dataset dei vettori opportunamente mischiati
% Label           label corrispondenti al dataset mischiato (gt per la classificazione)
%
% Giacomo Boracchi
% Politecnico di Milano
% December 2010
% giacomo.boracchi@polimi.it
%
% Revision History
% [....]
% September 2013 - added generation of Bernoulli sequences

if exist('label1', 'var')  == 0 || isempty(label1)
    label1 = 1;
end

if exist('label2', 'var')  == 0 || isempty(label2)
    label2 = 2;
end

if exist('do_show', 'var')  == 0 || isempty(do_show)
    do_show = 0;
end

if exist('do_shuffle', 'var')  == 0 || isempty(do_shuffle)
    do_shuffle = 1;
end

if exist('figureNumber', 'var') == 0 || isempty(figureNumber)
    figureNumber = round(1000*rand(1));
end

datasetLength1 = round(datasetLength * r);
datasetLength2 = datasetLength - datasetLength1;

% class1
if strcmpi(pdf1 , 'gaussian')
    DataSet = params1(2) * randn(1 , datasetLength1) + params1(1);
end

if strcmpi(pdf1 , 'poisson') || strcmpi(pdf1 , 'poissonian')
    DataSet = poissrnd(params1(1) , [1 , datasetLength1]);
end

if strcmpi(pdf1 , 'poisson+gauss') || strcmpi(pdf1 , 'poissonianGaussian')
    DataSet = poissrnd(params1(1) , [1 , datasetLength1]) + params1(2) * randn(1 , datasetLength1);
end

if strcmpi(pdf1 , 'laplace') || strcmpi(pdf1 , 'laplacian')
    DataSet = laprnd(1 , datasetLength1, params1(1), params1(2));
end

if strcmpi(pdf1 , 'uniform') % uniform in [params1(1) , params1(2)]
    DataSet = params1(1) + (params1(2) - params1(1)) * rand(1 , datasetLength1);
end

if strcmpi(pdf1 , 'bernoulli') ||  strcmpi(pdf1 , 'bernulli') % uniform in [params1(1) , params1(2)]
    DataSet = binornd(1, params1(1), 1, datasetLength1);
end

% class2
if strcmpi(pdf2 , 'gaussian')
    DataSet = [DataSet , params2(2) * randn(1 , datasetLength2) + params2(1)];
end

if strcmpi(pdf2 , 'poisson') || strcmpi(pdf2 , 'poissonian')
    DataSet = [DataSet , poissrnd(params2(1) , [1 , datasetLength2])];
end

if strcmpi(pdf2 , 'uniform') % uniform in [params1(1) , params1(2)]
    DataSet = [DataSet , params2(1) + (params2(2) - params2(1)) * rand(1 , datasetLength2)];
end

if strcmpi(pdf1 , 'bernoulli') ||  strcmpi(pdf1 , 'bernulli') % uniform in [params1(1) , params1(2)]
    DataSet =  [DataSet , binornd(1, params2(1), 1, datasetLength2)];
end

% the two datasets are shuffled together with their labels (it does make sense only for classification purposes)
if do_shuffle
    newIndices = randperm(datasetLength);
    Label = [ones(1 , datasetLength1) * label1 , ones(1 , datasetLength2) * label2];
    DataSet = DataSet(newIndices);
    Label = Label(newIndices);
else
    Label = [ones(1 , datasetLength1 + datasetLength2)];
end

% we assume that the expected value over both classes increases linearly from 0 to m at the end of the dataset
% from [param1_changed(1), param2_changed(1)] till [param1_changed(1), param2_changed(1)] *driftCoefficients(1)
qTerms = m / datasetLength .* [1 : 1 : datasetLength];

% add the drift term
DataSet = DataSet + qTerms;

if do_show
    figure(figureNumber), plot(find(Label == label1), DataSet(find(Label == label1)) , 'r.'),
    hold on
    plot(find(Label == label2), DataSet(find(Label == label2)) , 'b.');
    hold off    
end



