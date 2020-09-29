function [DS , Label] = f_creaDataSetMultiChanges(ampiezze, r, pdf1, pdf2, params1, params2, m, do_shuffle, do_show, label1, label2, figureNumber)
%
% function  [DS , Label] =  f_creaDataSetMultiChanges(ampiezze, r, pdf1, pdf2, params1, params2, m, do_shuffle, do_show, label1, label2, figureNumber)
%
% Permette di generare dataset (DS) per la classificazione/ change detection caratterizzati da più changes.
%
% input
% ampiezze          amoplitude of each stationary segment of the dataset (stationary or linearly drifting if m!=0)
% r                 output distribution of the first class (i.e. percentage of sample of class1)
% pdf1, pdf2        pdf of both classess. 'gaussian' , 'poisson' , 'uniform'
% params1, params2  pdf parameters.
%                   pdf == 'gaussian' params = [mu , sigma]
%                   pdf == 'poisson' params = lambda
%                   pdf == 'uniform' params = [a , b] (distribution interval)
% m                 drift coeffcients. It affects the expected value of X
% do_shuffle         (optional, defualt 1)
% do_show           (optional, defualt 0)
% label1,label2     classes label (optional, defualt 1,2)
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
% Revision History
% December 2013    Engineering
%
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

MRK_SZ = 10;
LN_WDT = 3;

for ii = 1 : 1 : length(ampiezze)
    
    if iscell(pdf1)
        pdf1_t = pdf1{ii};
    else
        pdf1_t = pdf1;
    end
    
    if iscell(pdf2)
        pdf2_t = pdf2{ii};
    else
        pdf2_t = pdf2;
    end
    
    if size(params1 , 1) < ii
        p1 = params1(end , :);
    else
        p1 = params1(ii , :);
    end
    
    if size(params2 , 1) < ii
        p2 = params2(end , :);
    else
        p2 = params2(ii , :);
    end
    
    if size(m , 1) < ii
        m_t = m(end);
    else
        m_t = m(ii);
    end
    
    if size(r , 1) < ii
        r_t = r(end);
    else
        r_t = r(ii);
    end
    
    [DS_temp , Label_temp] = f_creaStationaryDataSet(ampiezze(ii), r_t, pdf1_t, pdf2_t, p1 , p2, m_t, do_shuffle, 0, label1 , label2);
    
    DS = [DS , DS_temp];
    Label = [Label , Label_temp];
    
end
LN_WDT = 3;
FNT_SZ = 14;
DWN = 5;
if do_show
    figure(figureNumber), cla
    indx1 = find(Label == label1);
    indx2 = find(Label == label2);
    indx1 = indx1(1 : DWN : end);
    indx2 = indx2(1 : DWN : end);
    plot(indx1, DS(indx1) , 'rx' , 'LineWidth', LN_WDT, 'MarkerSize' , MRK_SZ),
    hold on
    plot(indx2, DS(indx2) , 'bo' , 'LineWidth', LN_WDT, 'MarkerSize' , MRK_SZ);
    axis tight
    a = get(gca);
    range = a.YLim;
    aa = 0;
    for ii = 1 : length(ampiezze)
        aa = aa + ampiezze(ii);
        plot([aa , aa] , range , 'g--' , 'LineWidth' , LN_WDT);
    end
    l = legend('class \omega_1' , 'class \omega_2', 'T^*');
    set(l, 'location' , 'northwest');
    hold off
    xlabel('time', 'FontSize', FNT_SZ)
    ylabel('observations', 'FontSize', FNT_SZ)
    set(gca, 'FontSize', FNT_SZ)
end