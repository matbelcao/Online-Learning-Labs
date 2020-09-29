function [DataSet, Label, Concept_Lengths]= f_createDatasetDrift(testID, N, m)
%
% function [DataSet, Label, Concept_Lengths]= f_createDatasetDrift(testID, N, m)
%
%
% Online Learning And Monitoring
% Giacomo Boracchi
% May 2020
%
% Politecnico di Milano
% giacomo.boracchi@polimi.it
% 

[Concept_Lengths, params0, params1] = defineExperimentParameters(testID, N, m);

if testID < 200
    pdf1 = 'Gaussian';
    pdf2 = 'Gaussian';
    RATIO = 0.5; % percentage of class 1 data
    [DataSet , Label] = f_creaDataSetMultiChanges(Concept_Lengths, RATIO, pdf1 , pdf2, params0, params1, M);
 
else
    [DataSet, Label] = f_creaDataSetMultiChangesMultivariate(Concept_Lengths, params1, params0);
 
end

Label = Label == 1;