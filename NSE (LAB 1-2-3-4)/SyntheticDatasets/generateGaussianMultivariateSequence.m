function [DataSet , Label] = generateGaussianMultivariateSequence(N , mu0 , Sigma0 , mu1 , Sigma1 , ratio , alternate_classes , label1 , label2)
% 
% function [DataSet , Label] = generateGaussianMultivariateSequence(N , mu0 , Sigma0 , mu1 , Sigma1 , ratio , alternate_classes , label1 , label2)
% 
%
% Giacomo Boracchi
% Politecnico di Milano
% giacomo.boracchi@polimi.it
%
% Revision History
% April 2012     - Frist Release

if ~exist('alternate_classes', 'var')
    alternate_classes = 0;
end

if ~exist('label1', 'var')
label1 = 1;
end

if ~exist('label2' , 'var')
label2 = 2;
end

if ~exist('Sigma0' , 'var')
    Sigma0 = diag(size(mu0 , 1));
end

if ~exist('Sigma1' , 'var')
    Sigma1 = diag(size(mu1 , 1));
end

n0 = round(ratio *N);
n1 = N - n0;

y0 = generateGaussianMultivariate(n0 , Sigma0)'+ mu0(: , ones(1 , n0));
l0 = label1 * ones(1 , size(y0 , 2));

y1 = generateGaussianMultivariate(n1 , Sigma1)' + mu1(: , ones(1 , n0));
l1 = label2 * ones(1 , size(y0 , 2));

if (ratio == 0.5 && alternate_classes == 1)
    DataSet(: , 1 : 2 : N) = y0;
    Label(1 : 2 : N) = label1;
    DataSet(: , 2 : 2 : N) = y1;
    Label(2 : 2 : N) = label2;
else
    newIndexes = randperm(N);
    DataSet = [y0 , y1];
    Label = [l0 , l1];
    DataSet = DataSet(: , newIndexes);
    Label = Label(: , newIndexes);
end




