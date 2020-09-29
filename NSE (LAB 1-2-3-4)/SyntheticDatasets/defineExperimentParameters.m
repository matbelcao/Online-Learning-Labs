function [AMPIEZZE, params0, params1, N, M, recurrentConceptGT] = defineExperimentParameters(testID, N, m)
%
% function [AMPIEZZE , params0 , params1 , N , M] = defineExperimentParameters(testID , N , m)
%
% N size of the dataset
% m supervised samples rate
%
%
% Giacomo Boracchi
% Politecnico di Milano
% December 2011
% giacomo.boracchi@polimi.it
%
% Revision History
% January 2012  First Release

if(~exist('m' , 'var') || isempty(m) || m == 0)
    m = 5;
end

mu0 = 0;
mu1 = 2.5;

sigma0 = 2;
sigma1 = 2;

DRIFT_PARAM = 0;

M = [0 , DRIFT_PARAM];

recurrentConceptGT = [];

switch testID
    case 1,
        %  one class shifts
        DELTA0 = 0;
        DELTA1 =2;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        % parameters for class 1 before and after the change
        params0 = [mu0 sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0];
        % parameters for class 1 before and after the change
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1];
        AMPIEZZE = [round(N / 2) round(N / 2)];
        
    case 2,
        % classes swap 
        DELTA0 = 2.5;
        DELTA1 = - 2.5;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1];
        AMPIEZZE = [round(N / 2) round(N / 2)];
        
    case 3,
        % abrupt change affecting both classes
        DELTA0 = 2;
        DELTA1 = 2;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1];
        AMPIEZZE = [round(N / 2) , N - round(N / 2)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1)+1 : N];
    case 4,
        % transient change affecting more the error than the data
        DELTA0 = 2;
        DELTA1 = 2;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 4) round(N / 4) round(N /2)];
        
    case 5,% SCALAR_2
        % alternting concepts, abrupt change
        DELTA0 = 2;
        DELTA1 = 2;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 51,% SCALAR_2 con delta 1 = 0.5 sigma
        % alternting concepts, abrupt change
        
        DELTA0 = 1;
        DELTA1 = 1;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 52,% SCALAR_2 con delta 0.5 = 0.25 sigma
        % alternting concepts, abrupt change
        
        DELTA0 = 0.5;
        DELTA1 = 0.5;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 6,
        % alternting concepts, abrupt change
        DELTA0 = 1;
        DELTA1 = 1;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 , sigma0 ];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 7 % SCALAR 3
        % alternting concepts, abrupt classes swap
        params0 = [mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0];
        params1 = [mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 71 % SCALAR 3 con delta = 1.5
        % alternting concepts, abrupt classes swap
        mu1 = 2;
        params0 = [mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0];
        params1 = [mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 72 % SCALAR 3 con delta = 1
        % alternting concepts, abrupt classes swap
        mu1 = 1.75;
        params0 = [mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0];
        params1 = [mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1 ; mu0 , sigma0 ; mu1 , sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 8, % SCALAR 4
        % stairs, sequence of change
        DELTA0 = 2;
        DELTA1 = 2;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 + 2 * DELTA0 , sigma0 ; mu0 + 3 * DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 + 4 * DELTA0 , sigma0];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 + 2 * DELTA1 , sigma1 ; mu1 + 3 * DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1  + 4 * DELTA1, sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5)  N - 4 * round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1) + 1 : 2 * AMPIEZZE(1)];
        recurrentConceptGT{3} = [2 * AMPIEZZE(1) + 1 : 3 * AMPIEZZE(1)];
        recurrentConceptGT{4} = [3 * AMPIEZZE(1) + 1 : 4 * AMPIEZZE(1)];
        recurrentConceptGT{5} = [4 * AMPIEZZE(1) + 1 : 5 * AMPIEZZE(1)];

        
    case 81, % SCALAR 4 con delta  1 =  0.5 sigma
        % stairs, sequence of change
        DELTA0 = 1;
        DELTA1 = 1;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 + 2 * DELTA0 , sigma0 ; mu0 + 3 * DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 + 4 * DELTA0 , sigma0];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 + 2 * DELTA1 , sigma1 ; mu1 + 3 * DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1  + 4 * DELTA1, sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1) + 1 : 2 * AMPIEZZE(1)];
        recurrentConceptGT{3} = [2 * AMPIEZZE(1) + 1 : 3 * AMPIEZZE(1)];
        recurrentConceptGT{4} = [3 * AMPIEZZE(1) + 1 : 4 * AMPIEZZE(1)];
        recurrentConceptGT{5} = [4 * AMPIEZZE(1) + 1 : 5 * AMPIEZZE(1)];
        
    case 82, % SCALAR 4 con delta  0.5 =  0.25 sigma
        % stairs, sequence of change
        DELTA0 = 0.5;
        DELTA1 = 0.5;
        DELTA_SIGMA0 =  0;
        DELTA_SIGMA1 =  0;
        
        params0 = [mu0 , sigma0 ; mu0 + DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 + 2 * DELTA0 , sigma0 ; mu0 + 3 * DELTA0 , sigma0 + DELTA_SIGMA0 ; mu0 + 4 * DELTA0 , sigma0];
        params1 = [mu1 , sigma1 ; mu1 + DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1 + 2 * DELTA1 , sigma1 ; mu1 + 3 * DELTA1 , sigma1 + DELTA_SIGMA1 ; mu1  + 4 * DELTA1, sigma1];
        AMPIEZZE = [round(N / 5) round(N / 5) round(N / 5) round(N / 5) round(N / 5)];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1) + 1 : 2 * AMPIEZZE(1)];
        recurrentConceptGT{3} = [2 * AMPIEZZE(1) + 1 : 3 * AMPIEZZE(1)];
        recurrentConceptGT{4} = [3 * AMPIEZZE(1) + 1 : 4 * AMPIEZZE(1)];
        recurrentConceptGT{5} = [4 * AMPIEZZE(1) + 1 : 5 * AMPIEZZE(1)];
        
        % no recurrent
    case 201 % CHECKERBOARD_1
        params1 = 'cb';  % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        cb_side = 0.5;
        
        params0(1).cb_side = cb_side ;
        params0(1).cb_alpha = 0;
        
        params0(2).cb_side = cb_side ;
        params0(2).cb_alpha = 30;
        
        params0(3).cb_side = cb_side ;
        params0(3).cb_alpha = 60;
        
        params0(4).cb_side = cb_side ;
        params0(4).cb_alpha = 90;
        
        params0(5).cb_side = cb_side;
        params0(5).cb_alpha = 120;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1) + 1 : 2 * AMPIEZZE(1)];
        recurrentConceptGT{3} = [2 * AMPIEZZE(1) + 1 : 3 * AMPIEZZE(1)];
        recurrentConceptGT{4} = [3 * AMPIEZZE(1) + 1 : 4 * AMPIEZZE(1)];
        recurrentConceptGT{5} = [4 * AMPIEZZE(1) + 1 : 5 * AMPIEZZE(1)];
     
    case 202   % checkerboard recurrent
        
        params1 = 'cb'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        cb_side = 0.5;
        
        params0(1).cb_side = cb_side ;
        params0(1).cb_alpha = 0;
        
        params0(2).cb_side = cb_side ;
        params0(2).cb_alpha = 30;
        
        params0(3).cb_side = cb_side ;
        params0(3).cb_alpha = 0;
        
        params0(4).cb_side = cb_side ;
        params0(4).cb_alpha = 30;
        
        params0(5).cb_side = cb_side;
        params0(5).cb_alpha = 0;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 203 % checkerboard no recurrent
        
        params1 = 'cb';  % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        cb_side = 0.5;
        
        params0(1).cb_side = cb_side ;
        params0(1).cb_alpha = 0;
        
        params0(2).cb_side = cb_side ;
        params0(2).cb_alpha = 45;
        
        params0(3).cb_side = cb_side ;
        params0(3).cb_alpha = 90;
        
        params0(4).cb_side = cb_side ;
        params0(4).cb_alpha = 135;
        
        params0(5).cb_side = cb_side;
        params0(5).cb_alpha = 180;
        
        params0(6).cb_side = cb_side ;
        params0(6).cb_alpha = 225;
        
        params0(7).cb_side = cb_side ;
        params0(7).cb_alpha = 270;
        
        params0(8).cb_side = cb_side ;
        params0(8).cb_alpha = 315;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 204 % checkerboard  recurrent
        
        params1 = 'cb';   % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        cb_side = 0.5;
        
        params0(1).cb_side = cb_side ;
        params0(1).cb_alpha = 0;
        
        params0(2).cb_side = cb_side ;
        params0(2).cb_alpha = 45;
        
        params0(3).cb_side = cb_side ;
        params0(3).cb_alpha = 0;
        
        params0(4).cb_side = cb_side ;
        params0(4).cb_alpha = 45;
        
        params0(5).cb_side = cb_side;
        params0(5).cb_alpha = 0;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 205 % checkerboard  recurrent
        
        params1 = 'cb';  % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        cb_side = 0.5;
        
        params0(1).cb_side = cb_side ;
        params0(1).cb_alpha = 0;
        
        params0(2).cb_side = cb_side ;
        params0(2).cb_alpha = 60;
        
        params0(3).cb_side = cb_side ;
        params0(3).cb_alpha = 120;
        
        params0(4).cb_side = cb_side ;
        params0(4).cb_alpha = 180;
        
        params0(5).cb_side = cb_side;
        params0(5).cb_alpha = 240;
        
        params0(6).cb_side = cb_side;
        params0(6).cb_alpha = 300;
        
        params0(7).cb_side = cb_side;
        params0(7).cb_alpha = 360;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        amp = AMPIEZZE(1);
        recurrentConceptGT{1} = [1 : 1 * amp , 3 * amp : 4 * amp , 6 * amp : 7 * amp];
        recurrentConceptGT{2} = [1 * amp : 2 * amp , 4 * amp : 5 * amp];
        recurrentConceptGT{3} = [2 * amp : 3 * amp , 5 * amp : 6 * amp];
        
        
    
    case 212    % GAUSS 2
        R = 0.5;
        params1 = 'gaussian'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).mu0 = [0 ; 0];
        params0(1).Sigma0 = 1 * eye(2);
        params0(1).mu1 = [2 ; 0];
        params0(1).Sigma1 = 4 * eye(2);
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        
        params0(2).mu0 = [1.5 ; -1.5];
        params0(2).Sigma0 = 1 * eye(2);
        params0(2).mu1 = [3.5 ; -1.5];
        params0(2).Sigma1 = 4 * eye(2);
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1)+1 : N];
        
        case 211    % GAUSS GAMA
        R = 0.5;
        params1 = 'gaussian'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).mu0 = [0 ; 0];
        params0(1).Sigma0 = 1 * eye(2);
        params0(1).mu1 = [2 ; 0];
        params0(1).Sigma1 = 4 * eye(2);
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        
        params0(2).mu0 = [2 ; 0];
        params0(2).Sigma0 = 4 * eye(2);
        params0(2).mu1 = [0 ; 0];
        params0(2).Sigma1 = 1 * eye(2);
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1)+1 : N];
        
        case 2111    % GAUSS GAMA, I changed the variance
        R = 0.5;
        params1 = 'gaussian'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).mu0 = [0 ; 0];
        params0(1).Sigma0 = 1 * eye(2);
        params0(1).mu1 = [2 ; 0];
        params0(1).Sigma1 = 4 * eye(2);
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        
        params0(2).mu0 = [2 ; 0];
        params0(2).Sigma0 = 4 * eye(2);
        params0(2).mu1 = [0 ; 0];
        params0(2).Sigma1 = 10 * eye(2); % change!!!!
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1)];
        recurrentConceptGT{2} = [AMPIEZZE(1)+1 : N];
        
       
    case 213 % gaussian, recurrent GAMA GAUSS 6
        R = 0.5;
        SIGMA = 4;
        params1 = 'gaussian';  % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).mu0 = [0 ; 0];
        params0(1).Sigma0 = SIGMA * eye(2);
        params0(1).mu1 = [2 ; 0];
        params0(1).Sigma1 =params0(1).Sigma0 ;
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
                
        params0(2).mu0 = [2 ; 0];
        params0(2).Sigma0 = SIGMA * eye(2);
        params0(2).mu1 = [0 ; 0];
        params0(2).Sigma1 =params0(2).Sigma0 ;
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        
        params0(3).mu0 = [0 ; 0];
        params0(3).Sigma0 = SIGMA * eye(2);
        params0(3).mu1 = [2 ; 0];
        params0(3).Sigma1 =params0(3).Sigma0 ;
        params0(3).ratio = R;
        params0(3).alternate_classes = 0;
        
        params0(4).mu0 = [2 ; 0];
        params0(4).Sigma0 = SIGMA * eye(2);
        params0(4).mu1 = [0 ; 0];
        params0(4).Sigma1 =params0(4).Sigma0 ;
        params0(4).ratio = R;
        params0(4).alternate_classes = 0;
        
        params0(5).mu0 = [0 ; 0];
        params0(5).Sigma0 = SIGMA * eye(2);
        params0(5).mu1 = [2 ; 0];
        params0(5).Sigma1 =params0(5).Sigma0 ;
        params0(5).ratio = R;
        params0(5).alternate_classes = 0;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
     
    case 221     % SIN, Abrupt concept drift GAMA
        R = 0.5;
        params1 = 'sine'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).range = [0 , 1];
        params0(1).classificationFunction = @(x , y)  (y - sin(x)); % if <0  then class1 otherwise, class2
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        params0(1).n_random_attributes = 0;
        params0(1).noise_perc = class_noise;
        params0(1).m= m;

        params0(2).range = [0 , 1];
        params0(2).classificationFunction = @(x , y)  (-y + sin(x)); % if <0  then class1 otherwise, class2
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        params0(2).n_random_attributes = 0;
        params0(2).noise_perc = class_noise;
        params0(2).m= m;
        
        params0(3).range = [0 , 1];
        params0(3).classificationFunction = @(x , y)  (y - sin(x)); % if <0  then class1 otherwise, class2
        params0(3).ratio = R;
        params0(3).alternate_classes = 0;
        params0(3).n_random_attributes = 0;
        params0(3).noise_perc = class_noise;
        params0(3).m= m;
        
        params0(4).range = [0 , 1];
        params0(4).classificationFunction = @(x , y)  (-y + sin(x)); % if <0  then class1 otherwise, class2
        params0(4).ratio = R;
        params0(4).alternate_classes = 0;
        params0(4).n_random_attributes = 0;   
        params0(4).noise_perc = class_noise;
        params0(4).m= m;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
       
    case 222 % SIN2, Abrupt concept drift GAMA
        R = 0.5;
        params1 = 'sine'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).range = [0 , 1];
        params0(1).classificationFunction = @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        params0(1).n_random_attributes = 0;
        params0(1).noise_perc = class_noise;
        params0(1).m= m;
        
        params0(2).range = [0 , 1];
        params0(2).classificationFunction = @(x , y)  (-y + 0.5 + 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        params0(2).n_random_attributes = 0;
        params0(2).noise_perc = class_noise;
        params0(2).m= m;
        
        params0(3).range = [0 , 1];
        params0(3).classificationFunction = @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(3).ratio = R;
        params0(3).alternate_classes = 0;
        params0(3).n_random_attributes = 0;
        params0(3).noise_perc = class_noise;
        params0(3).m= m;
        
        params0(4).range = [0 , 1];
        params0(4).classificationFunction = @(x , y)  (-y + 0.5 + 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(4).ratio = R;
        params0(4).alternate_classes = 0;
        params0(4).n_random_attributes = 0;
        params0(4).noise_perc = class_noise;
        params0(4).m= m;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
     
    case 231   % SINIRREL, Abrupt concept drift GAMA
        R = 0.5;
        params1 = 'sine';  % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).range = [0 , 1];
        params0(1).classificationFunction = @(x , y)  (y - sin(x)); % if <0  then class1 otherwise, class2
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        params0(1).n_random_attributes = 2;
        params0(1).noise_perc = class_noise;
        params0(1).m= m;
        
        params0(2).range = [0 , 1];
        params0(2).classificationFunction = @(x , y)  (-y + sin(x)); % if <0  then class1 otherwise, class2
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        params0(2).n_random_attributes = 2;
        params0(2).noise_perc = class_noise;
        params0(2).m= m;
        
        params0(3).range = [0 , 1];
        params0(3).classificationFunction = @(x , y)  (y - sin(x)); % if <0  then class1 otherwise, class2
        params0(3).ratio = R;
        params0(3).alternate_classes = 0;
        params0(3).n_random_attributes = 2;
        params0(3).noise_perc = class_noise;
        params0(3).m= m;
        
        params0(4).range = [0 , 1];
        params0(4).classificationFunction = @(x , y)  (-y + sin(x)); % if <0  then class1 otherwise, class2
        params0(4).ratio = R;
        params0(4).alternate_classes = 0;
        params0(4).n_random_attributes = 2;
        params0(4).noise_perc = class_noise;
        params0(4).m= m;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
   
    case 232     % SIN2IRREL, Abrupt concept drift GAMA
        R = 0.5;
        params1 = 'sine'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).range = [0 , 1];
        params0(1).classificationFunction = @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(1).ratio = R;
        params0(1).alternate_classes= 0;
        params0(1).n_random_attributes = 2;
        params0(1).noise_perc = class_noise;
        params0(1).m= m;
        
        params0(2).range = [0 , 1];
        params0(2).classificationFunction = @(x , y)  (-y + 0.5 + 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(2).ratio = R;
        params0(2).alternate_classes= 0;
        params0(2).n_random_attributes = 2;
        params0(2).noise_perc = class_noise;
        params0(2).m= m;
        
        params0(3).range = [0 , 1];
        params0(3).classificationFunction = @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(3).ratio = R;
        params0(3).alternate_classes= 0;
        params0(3).n_random_attributes = 2;
        params0(3).noise_perc = class_noise;
        params0(3).m= m;
        
        params0(4).range = [0 , 1];
        params0(4).classificationFunction = @(x , y)  (-y + 0.5 + 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(4).ratio = R;
        params0(4).alternate_classes= 0;
        params0(4).n_random_attributes = 2;
        params0(4).noise_perc = class_noise;
        params0(4).m= m;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 241 % Moving Hyperplanes 2D, SEA , no recurrent, no noise
        
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).hyp_cube_center = 1;
        params0(2).hyp_cube_center = 1;
        params0(3).hyp_cube_center = 1;
        params0(4).hyp_cube_center = 1;
        
        params0(1).hypCoeffs = [-8 1 1 0];
        params0(2).hypCoeffs = [-9 1 1 0];
        params0(3).hypCoeffs = [-7 1 1 0];
        params0(4).hypCoeffs = [-9.5 1 1 0];

        params0(1).inputScaling = 10;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 10;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 10;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 10;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
                 
    case 242 % Moving Hyperplanes 2D, SEA , recurrent, no noise
        
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).hyp_cube_center = 1;
        params0(2).hyp_cube_center = 1;
        params0(3).hyp_cube_center = 1;
        params0(4).hyp_cube_center = 1;
        
        params0(1).hypCoeffs = [-8 1 1 0];
        params0(2).hypCoeffs = [-9 1 1 0];
        params0(3).hypCoeffs = [-8 1 1 0];
        params0(4).hypCoeffs = [-9 1 1 0];

        params0(1).inputScaling = 10;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 10;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 10;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 10;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
 
    case 243 % Moving Hyperplanes 2D, SEA , no recurrent, no noise
        
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0.1;
        
        params0(1).hyp_cube_center = 1;
        params0(2).hyp_cube_center = 1;
        params0(3).hyp_cube_center = 1;
        params0(4).hyp_cube_center = 1;
        
        params0(1).hypCoeffs = [-8 1 1 0];
        params0(2).hypCoeffs = [-9 1 1 0];
        params0(3).hypCoeffs = [-8 1 1 0];
        params0(4).hypCoeffs = [-9.5 1 1 0];

        params0(1).inputScaling = 10;
        params0(1) .m =m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 10;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 10;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 10;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
                
    case 244 % Moving Hyperplanes 2D, SEA , recurrent, no noise
        
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0.1;
        
        params0(1).hyp_cube_center = 1;
        params0(2).hyp_cube_center = 1;
        params0(3).hyp_cube_center = 1;
        params0(4).hyp_cube_center = 1;
        
        params0(1).hypCoeffs = [-8 1 1 0];
        params0(2).hypCoeffs = [-9 1 1 0];
        params0(3).hypCoeffs = [-8 1 1 0];
        params0(4).hypCoeffs = [-9 1 1 0];

        params0(1).inputScaling = 10;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 10;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 10;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 10;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
       
    case 251 % Moving Hyperplanes 2D, SEA like, no recurrent, no noise
        
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        class_noise = 0;
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [-2 1 1 0];
        params0(2).hypCoeffs = [-1 1 1 0];
        params0(3).hypCoeffs = [-3 1 1 0];
        params0(4).hypCoeffs = [-0.5 1 1 0];
        params0(5).hypCoeffs = [1.5 1 1 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 252 % Moving Hyperplanes 2D, SEA like,  recurrent, no noise
        class_noise = 0;
        params1 = 'hyperplanes';  % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [-2 1 1 0];
        params0(2).hypCoeffs = [-1 1 1 0];
        params0(3).hypCoeffs = [-2 1 1 0];
        params0(4).hypCoeffs = [-1 1 1 0];
        params0(5).hypCoeffs = [-2 1 1 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 253 % Moving Hyperplanes 2D, SEA like, no recurrent, noisy
        
        class_noise = 0.1;
        params1 = 'hyperplanes'; 
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [-2 1 1 0];
        params0(2).hypCoeffs = [-1 1 1 0];
        params0(3).hypCoeffs = [-3 1 1 0];
        params0(4).hypCoeffs = [-0.5 1 1 0];
        params0(5).hypCoeffs = [1.5 1 1 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 254 % Moving Hyperplanes 2D, SEA like, recurrent, noisy
        
        class_noise = 0.1;
        params1 = 'hyperplanes'; 
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [-2 1 1 0];
        params0(2).hypCoeffs = [-1 1 1 0];
        params0(3).hypCoeffs = [-2 1 1 0];
        params0(4).hypCoeffs = [-1 1 1 0];
        params0(5).hypCoeffs = [-2 1 1 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 261 % Moving Hyperplanes 2D, SEA like,  no recurrent, no noise  5D
        
        class_noise = 0;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 0 0];
        params0(2).hypCoeffs = [0 1 -1 1 0 0];
        params0(3).hypCoeffs = [0 -1 1 1 0 0];
        params0(4).hypCoeffs = [0 -3 -1 1 0 0];
        params0(5).hypCoeffs = [0 -5 -3 1 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 262 % Moving Hyperplanes 2D, SEA like,  recurrent, no noise  5D
        
        class_noise = 0;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 0 0];
        params0(2).hypCoeffs = [0 1 -1 1 0 0];
        params0(3).hypCoeffs = [0 3 1 1 0 0];
        params0(4).hypCoeffs = [0 1 -1 1 0 0];
        params0(5).hypCoeffs = [0 3 1 1 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 263 % Moving Hyperplanes 2D, SEA like,  No recurrent, noisy  5D
        
        class_noise = 0.1;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 0 0];
        params0(2).hypCoeffs = [0 1 -1 1 0 0];
        params0(3).hypCoeffs = [0 -1 1 1 0 0];
        params0(4).hypCoeffs = [0 -3 -1 1 0 0];
        params0(5).hypCoeffs = [0 -5 -3 1 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 264 % Moving Hyperplanes 2D, SEA like,  recurrent, noisy  5D
        
        class_noise = 0.1;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 0 0];
        params0(2).hypCoeffs = [0 1 -1 1 0 0];
        params0(3).hypCoeffs = [0 3 1 1 0 0];
        params0(4).hypCoeffs = [0 1 -1 1 0 0];
        params0(5).hypCoeffs = [0 3 1 1 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
    case 271 % Moving Hyperplanes 2D, SEA like, no recurrent, no noise  9D
        
        class_noise = 0;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        params0(2).hypCoeffs = [0 1 -1 -1 1 1 0 0 0 0];
        params0(3).hypCoeffs = [0 -1 1 1 1 1 0 0 0 0];
        params0(4).hypCoeffs = [0 -3 -1 -1 1 1 0 0 0 0];
        params0(5).hypCoeffs = [0 -5 -3 1 1 1 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 272 % Moving Hyperplanes 2D, SEA like,  recurrent, no noise 9D
        
        class_noise = 0;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        params0(2).hypCoeffs = [0 1 -1 -1 1 1 0 0 0 0];
        params0(3).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        params0(4).hypCoeffs = [0 1 -1 -1 1 1 0 0 0 0];
        params0(5).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 273 % Moving Hyperplanes 2D, SEA like,  no recurrent, noisy 9D
        class_noise = 0.1;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        params0(2).hypCoeffs = [0 1 -1 -1 1 1 0 0 0 0];
        params0(3).hypCoeffs = [0 -1 1 1 1 1 0 0 0 0];
        params0(4).hypCoeffs = [0 -3 -1 -1 1 1 0 0 0 0];
        params0(5).hypCoeffs = [0 -5 -3 1 1 1 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 274 % Moving Hyperplanes 2D, SEA like,  recurrent, noisy 9D
        class_noise = 0.1;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        params0(2).hypCoeffs = [0 1 -1 -1 1 1 0 0 0 0];
        params0(3).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        params0(4).hypCoeffs = [0 1 -1 -1 1 1 0 0 0 0];
        params0(5).hypCoeffs = [0 3 1 1 1 1 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 281 % Moving Hyperplanes 2D, SEA like, no recurrent, no noise  17D
        
        class_noise = 0;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        params0(2).hypCoeffs = [0 2 1 2 1 2 1 2 1 2 0 0 0 0 0 0 0 0];
        params0(3).hypCoeffs = [0 3 1 3 1 3 1 3 1 3 0 0 0 0 0 0 0 0];
        params0(4).hypCoeffs = [0 1 2 1 2 1 2 1 2 1 0 0 0 0 0 0 0 0];
        params0(5).hypCoeffs = [0 3 2 3 2 3 2 3 2 3 0 0 0 0 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        
    case 282 % Moving Hyperplanes 2D, SEA like,  recurrent, no noise 17D
        
        class_noise = 0;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        params0(2).hypCoeffs = [0 3 1 3 1 3 1 3 1 3 0 0 0 0 0 0 0 0];
        params0(3).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        params0(4).hypCoeffs = [0 3 1 3 1 3 1 3 1 3 0 0 0 0 0 0 0 0];
        params0(5).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
    case 283 % Moving Hyperplanes 2D, SEA like,  no recurrent, noisy 17D
        class_noise = 0.1;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        params0(2).hypCoeffs = [0 2 1 2 1 2 1 2 1 2 0 0 0 0 0 0 0 0];
        params0(3).hypCoeffs = [0 3 1 3 1 3 1 3 1 3 0 0 0 0 0 0 0 0];
        params0(4).hypCoeffs = [0 1 2 1 2 1 2 1 2 1 0 0 0 0 0 0 0 0];
        params0(5).hypCoeffs = [0 3 2 3 2 3 2 3 2 3 0 0 0 0 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
    case 284 % Moving Hyperplanes 2D, SEA like,  recurrent, noisy 17D
        class_noise = 0.1;
        params1 = 'hyperplanes'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).hyp_cube_center = 0;
        params0(2).hyp_cube_center = 0;
        params0(3).hyp_cube_center = 0;
        params0(4).hyp_cube_center = 0;
        params0(5).hyp_cube_center = 0;
        
        params0(1).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        params0(2).hypCoeffs = [0 3 1 3 1 3 1 3 1 3 0 0 0 0 0 0 0 0];
        params0(3).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        params0(4).hypCoeffs = [0 3 1 3 1 3 1 3 1 3 0 0 0 0 0 0 0 0];
        params0(5).hypCoeffs = [0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0];
        
        params0(1).inputScaling = 5;
        params0(1).m = m;
        params0(1).noise_perc = class_noise;
        
        params0(2).inputScaling = 5;
        params0(2).m = m;
        params0(2).noise_perc = class_noise;
        
        params0(3).inputScaling = 5;
        params0(3).m = m;
        params0(3).noise_perc = class_noise;
        
        params0(4).inputScaling = 5;
        params0(4).m = m;
        params0(4).noise_perc = class_noise;
        
        params0(5).inputScaling = 5;
        params0(5).m = m;
        params0(5).noise_perc = class_noise;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
 
    case {301,302,303,304} % SIN2 recurrent GAMA-like no noise, no recurrent
        
        if testID == 301
            class_noise = 0;
            n_irrel_attributes = 0;
        end
        
        if testID == 302
            class_noise = 0.1;
            n_irrel_attributes = 0;
        end
        
        if testID == 303
            class_noise = 0;
            n_irrel_attributes = 2;
        end
        
         if testID == 304
            class_noise = 0.1;
            n_irrel_attributes = 2;
        end
        
        R = 0.5;
        params1 = 'sine'; % string describing the experiment, required by f_creaDataSetMultiChangesMultivariate
        
        params0(1).range = [0 , 1];
        params0(1).classificationFunction =  @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(1).ratio = R;
        params0(1).alternate_classes = 0;
        params0(1).n_random_attributes = n_irrel_attributes;
        params0(1).noise_perc = class_noise;
        params0(1).m= m;
        
        params0(2).range = [0 , 1];
        params0(2).classificationFunction =  @(x , y)  (-y + 0.5 + 0.3 *sin(3 * pi * x)); % if <0  then class1
        params0(2).ratio = R;
        params0(2).alternate_classes = 0;
        params0(2).n_random_attributes = n_irrel_attributes;
        params0(2).noise_perc = class_noise;
        params0(2).m= m;
        
        params0(3).range = [0 , 1];
        params0(3).classificationFunction =   @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(3).ratio = R;
        params0(3).alternate_classes = 0;
        params0(3).n_random_attributes = n_irrel_attributes;
        params0(3).noise_perc = class_noise;
        params0(3).m= m;
        
        params0(4).range = [0 , 1];
        params0(4).classificationFunction =   @(x , y)  (-y + 0.5 + 0.3 *sin(3 * pi * x)); % if <0  then class1
        params0(4).ratio = R;
        params0(4).alternate_classes = 0;
        params0(4).n_random_attributes = n_irrel_attributes;
        params0(4).noise_perc = class_noise;
        params0(4).m= m;
        
        params0(5).range = [0 , 1];
        params0(5).classificationFunction =  @(x , y)  (y - 0.5 - 0.3 *sin(3 * pi * x)); % if <0  then class1 otherwise, class2
        params0(5).ratio = R;
        params0(5).alternate_classes = 0;
        params0(5).n_random_attributes = n_irrel_attributes;
        params0(5).noise_perc = class_noise;
        params0(5).m= m;
        
        n_segments = numel(params0);
        n1 = round(N / n_segments);
        AMPIEZZE = [ n1 * ones(1 , n_segments - 1) , N -  (n_segments - 1) * n1];
        
        recurrentConceptGT{1} = [1 : AMPIEZZE(1) , 2 *AMPIEZZE(2) : 3 * AMPIEZZE(3) , 4 * AMPIEZZE(4) : sum(AMPIEZZE)];
        recurrentConceptGT{2} = [AMPIEZZE(1) : 2 * AMPIEZZE(2) , 3 * AMPIEZZE(3) : 4 * AMPIEZZE(4)];
        
        
end

N = sum(AMPIEZZE);