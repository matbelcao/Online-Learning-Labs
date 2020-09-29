function plotDataSet(DataSet, Label, AMPLITUDES , figureNumber)
%
% function plotDataSet(DataSet , Label , AMPIEZZE , figureNumber)
%
% Giacomo Boracchi
% Politecnico di Milano
% giacomo.boracchi@polimi.it
%
% Revision History
% April 2012  - first Release

labels = unique(Label);
label1 = labels(1);
label2 = labels(2);
MRK_SZ = 10;
LN_WDT = 3;
FNT_SZ = 16;

if size(DataSet , 1) == 1
    
    plot(find(Label == label1), DataSet(find(Label == label1)) , 'r.' , 'Markersize' , 1);
    hold on
    plot(find(Label == label2), DataSet(find(Label == label2)) , 'b.', 'Markersize' , 1),
    maxDS = max(DataSet);
    minDS = min(DataSet);
    
else
    DWNS_FACTOR = 5;
    
    figure(figureNumber),
    cla
    
    ds_init = 1;
    ds_end = AMPLITUDES(1);
    ssa = zeros(size(DataSet , 1) , 1);
    DS_toShow = [DataSet(: , ds_init : ds_end) + ssa(: , ones(1, ds_end - ds_init + 1))];
    Label_toShow =[Label(: , ds_init : ds_end)];
    
    for ddss = 1 : length(AMPLITUDES) - 1
        ds_init = ds_init + AMPLITUDES(ddss);
        ds_end = ds_end + AMPLITUDES(ddss);
        datasetShift = max(DataSet(1 , ds_init : ds_end)) - min(DataSet(1 , ds_init : ds_end));
        ssa = ssa + [datasetShift ; zeros(size(DataSet , 1) - 1 , 1);];
        DS_toShow = [DS_toShow , DataSet(: , ds_init : ds_end) + ssa(: , ones(1, ds_end - ds_init + 1)) ];
        Label_toShow = [Label_toShow , Label(: , ds_init : ds_end)];
    end
    
    indx1 = find(Label(1 : size(DS_toShow , 2)) == label1);
    indx2 = find(Label(1 : size(DS_toShow , 2)) == label2);
    indx1 = indx1(1 : DWNS_FACTOR : end);
    indx2 = indx2(1 : DWNS_FACTOR : end);
    
    L(1, :) =  plot(DS_toShow(1 , indx1) , DS_toShow(2 , indx1) , 'rx' , 'MarkerSize' , MRK_SZ , 'LineWidth' , LN_WDT);
    hold on
    L(2, :)= plot(DS_toShow(1 , indx2) , DS_toShow(2 , indx2) , 'bo' , 'MarkerSize' , MRK_SZ , 'LineWidth' , LN_WDT);
    
    legend(L, 'class \omega_1' , 'class \omega_2')
    legend('location' , 'northwest')
    
    for ddss = 1 : length(AMPLITUDES)
        if ddss == 1
            baryCenter = mean(DS_toShow(:, 1 : AMPLITUDES(1)), 2);
            str =  sprintf('t = %d - %d', 1, AMPLITUDES(1));
        else
            dsInit = sum(AMPLITUDES(1 : ddss - 1));
            dsEnd = sum(AMPLITUDES(1 : ddss));
            baryCenter = mean(DS_toShow(:, dsInit : dsEnd), 2);
            str =  sprintf('t = %d - %d', dsInit, dsEnd);
        end
        text(baryCenter(1), min(DataSet(1,:)), str, 'FontSize', FNT_SZ);
    end
    
    hold off
    set(gca , 'FontSize' , FNT_SZ);
    xlabel('x_1')
    ylabel('x_2')
    title([' DataSet has ', num2str(numel(AMPLITUDES)), ' concepts, distributions shown 1 sample out of ' , num2str(DWNS_FACTOR)]);
    axis equal
    
end