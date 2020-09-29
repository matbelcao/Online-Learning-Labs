function [DS , Label] = f_creaDataSetMultiChangesMultivariate(ampiezze, type, params, do_shuffle, do_show, label1, label2, figureNumber)
%
% function [DS , Label] = f_creaDataSetMultiChangesMultivariate(ampiezze, type, params, do_shuffle, do_show, label1, label2, figureNumber)
%
% Permette di generare dataset (DS) per la classificazione/ change detection caratterizzati da più changes.
%
% input
% ampiezze          amoplitude of each stationary segment of the dataset (stationary or linearly drifting if m!=0)
% r                 output distribution of the first class (i.e. percentage of sample of class1)
% pdf1, pdf2        pdf of both classess. 'gaussian' , 'poisson' , 'uniform'
% params1, params2  pdf parameters.
%                               pdf == 'gaussian' params = [mu , sigma]
%                               pdf == 'poisson' params = lambda
%                               pdf == 'uniform' params = [a , b] (distribution interval)
% m                          drift coeffcients. It affects the expected value of X
% label1,label2        classes label (optional)
% do_show              (optional)
% figureNumber      (optional)
%
% OUTPUT
%
% DS         dataset dei vettori opportunamente mischiati
% Label           label corrispondenti al dataset mischiato (gt per la classificazione)
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

if exist('do_shuffle', 'var') == 0 || isempty(do_shuffle)
    do_shuffle = 1;
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

if exist('figureNumber', 'var') == 0 || isempty(figureNumber)
    figureNumber = round(1000*rand(1));
end

DS = [];
Label = [];
DS_toShow = [];
MRK_SZ = 10;

for ii = 1 : 1 : length(ampiezze)
    
    if numel(params) < ii
        p1 = params(end);
    else
        p1 = params(ii);
    end
    
    [DS_temp , Label_temp] = f_creaStationaryDataSetMultivariate(ampiezze(ii), type, p1, do_shuffle, do_show, label1 , label2, figureNumber);
    
    DS = [DS , DS_temp];
    Label = [Label , Label_temp];
end

if do_show
    DWNS_FACTOR = 1;
    LN_WDT = 2;
    
    figure(figureNumber),
    cla
    indx1 = find(Label == label1);
    indx2 = find(Label == label2);
    
    indx1 = indx1(1 : DWNS_FACTOR : end);
    indx2 = indx2(1 : DWNS_FACTOR : end);
    
    DS_toShow = [];
    ds_init = 1;
    ds_end = ampiezze(1);
    ssa = zeros(size(DS , 1) , 1);
    DS_toShow = [DS_toShow , DS(: , ds_init : ds_end) + ssa(: , ones(1, ds_end - ds_init + 1)) ];
    
    for ddss = 1 : length(ampiezze) -1
        ds_init = ds_init + ampiezze(ddss);
        ds_end = ds_end + ampiezze(ddss);
        datasetShift = max(DS(1 , ds_init : ds_end)) - min(DS(1 , ds_init : ds_end));
        ssa = ssa + [datasetShift ; zeros(size(DS , 1) - 1 , 1);];
        DS_toShow = [DS_toShow , DS(: , ds_init : ds_end) + ssa(: , ones(1, ds_end - ds_init + 1)) ];
    end
    
    plot(DS_toShow(1 , indx1) , DS_toShow(2 , indx1) , 'rx' , 'MarkerSize', MRK_SZ, 'LineWidth' , LN_WDT),
    hold on
    plot(DS_toShow(1 , indx2) , DS_toShow(2 , indx2) , 'bo' , 'MarkerSize', MRK_SZ, 'LineWidth' , LN_WDT),
    legend('class \omega_1' , 'class \omega_2')
    legend('location' , 'northwest')
    hold off
    xlabel('x1')
    ylabel('x2')
    title([' DataSet has ', num2str(numel(ampiezze)), ' concepts, distributions shown 1 sample every ' , num2str(DWNS_FACTOR)]);
    axis equal
end