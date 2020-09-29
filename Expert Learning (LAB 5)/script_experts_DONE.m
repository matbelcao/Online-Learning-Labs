clear;
clc;
close all;
addpath(genpath('.'));

%% Expert Setting

%Environment
T = 3000;
useEWA = true;

pred = zeros(T,1);
loss = zeros(T,1);
y_t = [];

experts = {@constant_exp, @greedy_exp, @window_exp};
n_exp = length(experts);
exp_loss = zeros(n_exp, T);

% EWA
hat_w = ones(n_exp, 1); %w(i,t)
eta = 0.5;

for tt = 1:T
    % Experts Advice
    for ii = 1:3
        exp_advice(ii, 1) = experts{ii}(y_t); % columnar vector
    end
    
    % Algortithm choice   
    % pred(tt) =
    if useEWA
        pred(tt) = EWA(hat_w,exp_advice);
    else
        pred(tt) = FL(exp_loss(:,1:tt-1),exp_advice);
    end

    %Reward
    %[y, loss(tt), exp_loss(:, tt)] = random_walk_env(pred(tt), exp_advice, @quad_loss);
    %[y, loss(tt), exp_loss(:, tt)] = stochastic_env(pred(tt), exp_advice, @quad_loss);
    [y, loss(tt), exp_loss(:, tt)] = random_env(pred(tt), exp_advice, @quad_loss);
    
    %Update statistics
    eta = sqrt((8*log(n_exp))/tt);
    % hat_w
    if useEWA
        hat_w = hat_w.*exp(-eta*exp_loss(:,tt));
        hat_w = hat_w/sum(hat_w);
    end
    
    % Append the last prediction
    y_t = [y_t y];
end


%% Plot Losses
alg_loss = cumsum(loss);
exp_losses = cumsum(exp_loss');

figure();
plot([alg_loss exp_losses], 'LineWidth', 1);
legend('algorithm loss', 'constant exp', 'greedy exp', 'window exp');

%% Plot Regret
regret = cumsum(loss) - min(cumsum(exp_loss'), [], 2);
plot_regret(regret');
hold on

% Plot bounds
if useEWA
    plot(1:T, ((eta * (1:T)) / 8 ) + (log(n_exp)/eta)); 
    plot(1:T, sqrt((1:T)*log(n_exp)/2) + sqrt(log(n_exp)/8));
    legend('regret', 'EWA bound', 'EWA optimized bound');
else
    plot(1:T, 8* (log(1:T)+1));
    legend('regret', 'FL bound');
end
title("Regret");

%% Write the expression of the bound