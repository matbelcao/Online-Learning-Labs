clear;
clc;
close all;
addpath(genpath('.'));

%% Mab stochastic environment

R = [0.2 0.3 0.7 0.5]; % expecet rewards for each arms a(i)
n_arms = length(R); % number of arms

%Environment
T = 3000; %time
useUCB1 = true;

% UCB1 and TS parameters
N = zeros(1, n_arms); % number of visits of arm a(i)
cum_r = zeros(1, n_arms); % average reward arm a(i)

fig = figure();
ind = zeros(T,1); % arm pulled @ i-th round
rewards = zeros(T,1); % last played action reward

for tt = 1:T
    % Algortithm choice
    if useUCB1
        % UCB1
        ind(tt) = UCB1(cum_r, N, tt);
    else
        % Thompson Sampling "TS"
        ind(tt) = TS(cum_r, N, tt);
    end

    %Plot bounds
    fig = plot_UCB1bound(fig, T, tt, cum_r, N, R, ind(tt));
    
    %Reward drawn from a stochastic distribution
    rewards(tt) = stochastic_env(R, ind(tt));
    
    %Update statistics
    N(ind(tt)) = N(ind(tt)) + 1;
    cum_r(ind(tt)) = cum_r(ind(tt)) + rewards(tt);
end

%% Plot Pseudo Regret

%pseudo_regret =
pseudo_regret = cumsum (max(R) - R(ind));

plot_regret(pseudo_regret);

Delta = max(R) - R;
Delta = Delta(Delta > 0);

%UpperBound = 
if useUCB1
    UpperBound = 8 * sum(1./Delta) * log(1:T) + (1+(pi^2)/3) * sum(1 ./Delta);
    
    hold on
    plot(1:T, UpperBound, 'g');
    legend({'Pseudo Regret' 'UCB1 Upper Bound'}, 'Location', 'NorthWest');
    title("Pseudo Regret");
else
    % KL parameters to tune...
    epsilon = 0.5;
    c = 10;
    
    %Kullback-Leibler divergence "simple"
    %KL = sum(R .* (log(R)-log(max(R))));
    
    %KL as written in the slides, but results negative withou abs()....
    %KL = abs(sum((R.*log(R/max(R)))-((1-R).*log((1-R)/(1-max(R))))));
    
    %Kullback-Leibler divergence "symmetric variant"
    KL1 = sum(R .* (log2(R)-log2(max(R))));
    KL2 = sum(max(R) .* (log2(max(R))-log2(R)));
    KL = (KL1+KL2)/2;
    
    UpperBound = (1+epsilon) * sum(Delta) * (log(1:T)+log(log(1:T))) * (1/KL) + c;
    
    hold on
    plot(1:T, UpperBound, 'g');
    legend({'Pseudo Regret' 'Thompson Sampling Upper Bound'}, 'Location', 'NorthWest');
    title("Pseudo Regret");
end


%% Compute expected pseudo regret from 10 experiments
n_rep = 10; %number of reapeated experiments

rewards = zeros(T, n_rep); % the matrix containing the rewards for the 10 algorithm runs
for rr = 1:n_rep    
    N = zeros(1, n_arms);
    cum_r = zeros(1, n_arms);

    for tt = 1:T
        % Algortithm choice
        if useUCB1
            % UCB1
            ind(tt, rr) = UCB1(cum_r, N, tt);
        else
            % Thompson Sampling "TS"
            ind(tt, rr) = TS(cum_r, N, tt);
        end

        %Reward
        rewards(tt, rr) = stochastic_env(R, ind(tt, rr));
        
        %Update statistics
        N(ind(tt, rr)) = N(ind(tt, rr)) + 1;
        cum_r(ind(tt, rr)) = cum_r(ind(tt, rr)) + rewards(tt, rr);
    end
end


%% Plot Expected Pseudo Regret

%pseudo_regret =
pseudo_regret = cumsum (max(R) - mean(R(ind),2)); % mean(A,2) --> column vector containing the mean of each row

plot_regret(pseudo_regret');

hold on
plot(1:T, UpperBound, 'g');
if useUCB1
    legend({'10 Experiments Pseudo regret' 'UCB1 Upper Bound'}, 'Location', 'NorthWest');
else
    legend({'10 Experiments Pseudo Regret' 'Thompson Sampling Upper Bound'}, 'Location', 'NorthWest');
end
    
title("10 Experiments Pseudo Regret");
