function [DataSet , Labels] = f_creaStationaryDataSetMultivariate(ampiezza, type , params, do_rand_perm, do_show, label1, label2, figureNumber)
%
% function [DataSet , Labels] = f_creaStationaryDataSetMultivariate(ampiezza , type , params, do_rand_perm, do_show, label1 , label2, figureNumber)
%
% genera i dataset (DS) per classificazione o change detection. 
% I DS sono rappresentati da realizzazioni di un processo X, caratterizzato da 
% due classi distribuite come pdf1 e pdf2 con parametri params1 e params2.
% la probabilità di avere osservazioni della prima classe è r, della seconda classe 1-r
% m rappresenta il coefficiente angolare del drift sul valore atteso di entrambe le clas    si
% ampiezza indica la dimensione del DS
%
% INPUT
%
% ampiezza          DS length
% r                 probability of class1 (1-r) probability of class2
% pdf1, pdf2        pdf of both classess. 'gaussian' , 'poisson' , 'uniform'
% params1, params2  pdf parameters. 
%                   pdf == 'gaussian' params = [mu , sigma]
%                   pdf == 'poisson' params = lambda
%                   pdf == 'uniform' params = [a , b] (distribution interval)
% m                 drift coeffcients. It affects the expected value of X
% label1,label2     classes label (optional)
% do_show           (optional)
% figureNumber      (optional)
%
% OUTPUT
%
% DS         DS dei vettori opportunamente mischiati
% Label           label corrispondenti al DS mischiato (gt per la classificazione)
%
% Giacomo Boracchi
% Politecnico di Milano
% December 2010
% giacomo.boracchi@polimi.it
%
%
% Revision History
% December 2013    Engineering
%
% Build up the dataset concatenating stationary concepts

if exist('do_rand_perm', 'var') == 0 || isempty(do_rand_perm)
    do_rand_perm = 1;
end

if exist('do_show', 'var') == 0 || isempty(do_show)
    do_show = 0;
end

if exist('label1', 'var') == 0 || isempty(label1)
    label1 = 1;
end

if exist('label2', 'var') == 0 || isempty(label2)
    label2 = 2;
end

if (~exist('figureNumber' , 'var'))
    figureNumber = round(1000*rand(1));
end

switch(lower(type))
    
    case {'cb', 'checkerboard' , 'scacchiera'}
        [DataSet , Labels] = generateCbSequence(ampiezza , params.cb_side , params.cb_alpha);
            DataSet = DataSet';
            Labels = Labels';
            lab_vals = unique(Labels);
            Labels(find(Labels) == lab_vals(1)) = label1;
            Labels(find(Labels) == lab_vals(2)) = label2;
            
    case{'hyperplanes','hyp'}
           [DataSet , Labels] = generateMHSequence(ampiezza , params.hypCoeffs , params.inputScaling , params.m , params.noise_perc, params.hyp_cube_center);
           DataSet = DataSet';
           Labels = Labels';
           
    case{'sin' , 'seno' , 'sine'}
        [DataSet , Labels] = generateSinSequence(ampiezza , params.range , params.classificationFunction , params.n_random_attributes , params.ratio , params.alternate_classes , params.noise_perc , params.m);
        if do_rand_perm == 1
            warning('by deafault sin sequence has no random permutation')
            do_rand_perm = 0;
        end
        
   case{'gaussian'} 
        [DataSet , Labels] = generateGaussianMultivariateSequence(ampiezza , params.mu0 , params.Sigma0 , params.mu1 , params.Sigma1 , params.ratio , params.alternate_classes);
end

if do_show
    plotCheckerBoardDataSet(DataSet , Labels , label1 , label2 , figureNumber);
end

if do_rand_perm
    newIndices = randperm(ampiezza);
    
    % Sparpaglio i dati del DS *separatamente*
    DataSet= DataSet(: , newIndices);
    Labels = Labels(: , newIndices);
end



