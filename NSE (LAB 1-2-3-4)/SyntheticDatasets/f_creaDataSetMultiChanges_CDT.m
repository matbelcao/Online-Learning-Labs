function [DataSet, figureNumber] = f_creaDataSetMultiChanges_CDT(ampiezze, pdfStr, pdfParams, m, do_shuffle, do_show, figureNumber)
%
% function  [DataSet, figureNumber] = f_creaDataSetMultiChanges_CDT(ampiezze, pdfStr, pdfParams, m, do_shuffle, do_show, figureNumber)
%
% generate examples of datasets for CDT purposes 
%
% input description
%
% . ampiezze          a vector providing the amplitude of each stationary segment of the dataset (stationary or linearly drifting if m!=0) 
% . pdfStr,                 pdf of data 'gaussian' , 'poisson' , 'uniform'
% . pdfParams,    a matrix showing the pdf parameters. 
%                   pdfStr == 'gaussian' each row of params indicate [mu , sigma] in the correspnding chunk of data
%                   pdfStr == 'poisson' each row of params indicate the value of lambda in the correspnding chunk of data
%                   pdfStr == 'uniform'each row of params indicate the value [a,b] the distribution interval of the correspnding chunk of data
% m                 drift coeffcients. It affects the expected value of X
% do_show           (optional)
% figureNumber      (optional)
%
% OUTPUT
%
% DataSet               
% figureNumber           
%
% Giacomo Boracchi
% Politecnico di Milano
% December 2012
% giacomo.boracchi@polimi.it
%
% Revision History
% December 2013    Engineering
%
% Build up the dataset concatenating stationary concepts

label1 = 1;

if exist('do_shuffle', 'var') == 0 || isempty(do_shuffle)
    do_shuffle = 0;
end

if exist('do_show', 'var') == 0 || isempty(do_show)
    do_show = 0;
end

if exist('figureNumber', 'var') == 0 || isempty(figureNumber)
    figureNumber = round(1000*rand(1));
end

DataSet = [];
Label = [];

MRK_SZ = 10;
LN_WDT = 3;

RATIO = 1;

for ii = 1 : 1 : length(ampiezze)
    
    if iscell(pdfStr)
        pdf1_t = pdfStr{ii};
    else
        pdf1_t = pdfStr;
    end
    
     
    if size(pdfParams , 1) < ii
        p1 = pdfParams(end , :);
    else
        p1 = pdfParams(ii , :);
    end
    
    if size(m , 1) < ii
        m_t = m(end);
    else
        m_t = m(ii);
    end
    
    % this is meant to create dataset for classification, thus two different distribution for classes. For CDT purposes,
    % it is enough to replicate the input
    [DataSet_temp, Label_temp] = f_creaStationaryDataSet(ampiezze(ii), RATIO, pdf1_t, pdf1_t, p1, p1, m_t, do_shuffle);
    
    DataSet = [DataSet, DataSet_temp];
    Label = [Label, Label_temp];
    
end

if do_show
    figure(figureNumber), close
    figure(figureNumber),
    plot(find(Label == label1), DataSet(find(Label == label1)) , 'r.' , 'MarkerSize' , 2 * MRK_SZ),
    hold on
    a = get(gca);
    range = a.YLim;
    aa = 0;
    for ii = 1 : length(ampiezze)
        aa = aa + ampiezze(ii);
        plot([aa , aa] , range , 'g' , 'LineWidth' , LN_WDT);
    end
    hold off
    xlabel('time')
    ylabel('observations')
end