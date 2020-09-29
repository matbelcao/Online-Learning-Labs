function [DataSet , Label] = generateSinSequence(N , range , class_fnz, n_random_attributes , ratio , alternate_classes, noise_perc , m,  label1 , label2)
% 
%function [DataSet , Label] = generateSinSequence(N , range , class_fnz, n_random_attributes , ratio , alternate_classes, label1 , label2 , noise_perc, m)
%
% Generated Dataset according to function class_fnz. It ensures that ratio% of samples are from the first class and the remaining from the second
%
% Giacomo Boracchi
% Politecnico di Milano
% giacomo.boracchi@polimi.it
%
% Revision History
% April 2012     - Frist Release
% October 2012 - aggiunto noise 

if ~exist('alternate_classes', 'var')
    alternate_classes = 0;
end

if ~exist('noise_perc' , 'var')
    noise_perc = 0;
end

if ~exist('m' , 'var')
    m = 5;
end

if ~exist('label1', 'var') || isempty(label1)
    label1 = 1;
end

if ~exist('label2' , 'var') || isempty(label1)
    label2 = 2;
end



DataSet0 = [];
DataSet1 = [];

n0 = round(ratio *N);
n1 = N - n0;
n_elements_class0 = 0;
n_elements_class1 = 0;

while(n_elements_class0 < n0 || n_elements_class1 < n1)
    
    DataSetTemp = rand(2 , 2 * N);
    DataSetTemp(1 , :) = (max(range) - min(range)) * DataSetTemp(1 , :) + min(range);
    classificationFunctionValues = class_fnz(DataSetTemp(1 , :) , DataSetTemp(2 , :));
        
    DataSet0 = [DataSet0 , DataSetTemp(: , classificationFunctionValues < 0)];
    DataSet1 = [DataSet1 , DataSetTemp(: , classificationFunctionValues >= 0)];
    
    n_elements_class0 = size(DataSet0 , 2);
    n_elements_class1 = size(DataSet1 , 2);
    
end

DataSet0 = DataSet0(: , 1 : n0);
DataSet1 = DataSet1(: , 1 : n1);
Label = [label1 * ones(1 , n0) , label2 * ones(1, n1)];

if (ratio == 0.5 && alternate_classes == 1)
    DataSet(: , 1 : 2 : N) = DataSet0;
    Label(1 : 2 : N) = label1;
    DataSet(: , 2 : 2 : N) = DataSet1;
    Label(2 : 2 : N) = label2;
else
    newIndexes = randperm(N);
    DataSet = [DataSet0 , DataSet1];
    DataSet = DataSet(: , newIndexes);
    Label = Label(: , newIndexes);
end

%% add noise 
if noise_perc > 0
    indxSwapped  = [];
    SupervisedSamples = zeros(1 , N);
    SupervisedSamples(m : m : end) = 1;
    supervisedIndex = find(SupervisedSamples);
    nToSwap = length(supervisedIndex) * noise_perc;
    
    indxSwapped = supervisedIndex(randperm(length(supervisedIndex)));
    indxSwapped = indxSwapped(1 : nToSwap);
    
    % swap the classes label
    Label(indxSwapped) = mod(Label(indxSwapped) , 2) + 1;
end

%% add irrel attributes
if n_random_attributes > 0
    DataSetIrrel = rand(n_random_attributes , size(DataSet , 2));
    DataSet = [DataSet ; DataSetIrrel];
end


