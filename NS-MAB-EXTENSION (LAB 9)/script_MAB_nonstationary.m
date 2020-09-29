clear;
clear CDTUCB.m
clc;
close all;
addpath(genpath('.'));

%% Mab stochastic environment

R = [0.2 0.3 0.7 0.5; ...
    0.1 0.2 0.4 0.6; ...
    0.9 0.5 0.7 0.1; ...
    0.3 0.4 0.5 0.8];

T = 6000;
breakpoints = [1000 3000 5000];
gamma = numel(breakpoints);

plot_evolution(R, breakpoints, T);

n_arms = length(R);

% inizializations
pulls_UCB1 = zeros(T, n_arms);
pulls_TS = zeros(T, n_arms);
pulls_SWTS = zeros(T, n_arms);
pulls_SWUCB = zeros(T, n_arms);
pulls_SWUCB_TRICK = zeros(T, n_arms);

reward_UCB1 = zeros(T, n_arms);
reward_TS = zeros(T, n_arms);
reward_SWTS = zeros(T, n_arms);
reward_SWUCB = zeros(T, n_arms);
reward_SWUCB_TRICK = zeros(T, n_arms);

fig = figure();

ind_UCB1 = zeros(T,1);
ind_TS = zeros(T,1);
ind_SWTS = zeros(T,1);
ind_SWUCB = zeros(T,1);
ind_SWUCB_TRICK = zeros(T,1);

rewards_UCB1 = zeros(T,1);
rewards_TS = zeros(T,1);
rewards_SWTS = zeros(T,1);
rewards_SWUCB = zeros(T,1);
rewards_SWUCB_TRICK = zeros(T,1);

k = 0; %phase variable

for tt = 1:T
    
    % phase update
    if tt == 2^(k+1)
        k = k+1;
    end
    
    % Algortithm choice
    ind_UCB1(tt) = UCB1(reward_UCB1, pulls_UCB1, tt);
    ind_TS(tt) = TS(reward_TS, pulls_TS, tt);
    ind_SWTS(tt) = SWTS(reward_SWTS, pulls_SWTS, tt, T);
    ind_SWUCB(tt) = SWUCB(reward_SWUCB, pulls_SWUCB, tt, T, gamma);
    ind_SWUCB_TRICK(tt) = SWUCB_TRICK(reward_SWUCB_TRICK, pulls_SWUCB_TRICK, tt, k, gamma);
    
    %Plot bounds
    %fig = plot_UCB1bound(fig, T, tt, cum_r, N, R, ind(tt));
    
    %Reward
    rewards_UCB1(tt) = stochastic_nonst_env(R, breakpoints, tt, ind_UCB1(tt));
    rewards_TS(tt) = stochastic_nonst_env(R, breakpoints, tt, ind_TS(tt));
    rewards_SWTS(tt) = stochastic_nonst_env(R, breakpoints, tt, ind_SWTS(tt));
    rewards_SWUCB(tt) = stochastic_nonst_env(R, breakpoints, tt, ind_SWUCB(tt));
    rewards_SWUCB_TRICK(tt) = stochastic_nonst_env(R, breakpoints, tt, ind_SWUCB_TRICK(tt));
    
    
    %Update statistics
    pulls_UCB1(tt, ind_UCB1(tt)) = pulls_UCB1(tt, ind_UCB1(tt)) + 1;
    pulls_TS(tt, ind_TS(tt)) = pulls_TS(tt, ind_TS(tt)) + 1;
    pulls_SWTS(tt, ind_SWTS(tt)) = pulls_SWTS(tt, ind_SWTS(tt)) + 1;
    pulls_SWUCB(tt, ind_SWUCB(tt)) = pulls_SWUCB(tt, ind_SWUCB(tt)) + 1;
    pulls_SWUCB_TRICK(tt, ind_SWUCB_TRICK(tt)) = pulls_SWUCB_TRICK(tt, ind_SWUCB_TRICK(tt)) + 1;
    
    reward_UCB1(tt, ind_UCB1(tt)) = reward_UCB1(tt, ind_UCB1(tt)) + rewards_UCB1(tt);
    reward_TS(tt, ind_TS(tt)) = reward_TS(tt, ind_TS(tt)) + rewards_TS(tt);
    reward_SWTS(tt, ind_SWTS(tt)) = reward_SWTS(tt, ind_SWTS(tt)) + rewards_SWTS(tt);
    reward_SWUCB(tt, ind_SWUCB(tt)) = reward_SWUCB(tt, ind_SWUCB(tt)) + rewards_SWUCB(tt);
    reward_SWUCB_TRICK(tt, ind_SWUCB_TRICK(tt)) = reward_SWUCB_TRICK(tt, ind_SWUCB_TRICK(tt)) + rewards_SWUCB_TRICK(tt);
end

%% Plot Pseudo Regret

breakpoints = [0 breakpoints T];

n_phase = length(breakpoints);
for ii = 1:(n_phase-1)
    tt_ind = (breakpoints(ii)+1):breakpoints(ii+1);
    exp_rew = R(ii, :);
    pseudo_regret_UCB1(tt_ind) = max(exp_rew) - exp_rew(ind_UCB1(tt_ind));
    pseudo_regret_TS(tt_ind) = max(exp_rew) - exp_rew(ind_TS(tt_ind));
    pseudo_regret_SWTS(tt_ind) = max(exp_rew) - exp_rew(ind_SWTS(tt_ind));
    pseudo_regret_SWUCB(tt_ind) = max(exp_rew) - exp_rew(ind_SWUCB(tt_ind));
    pseudo_regret_SWUCB_TRICK(tt_ind) = max(exp_rew) - exp_rew(ind_SWUCB_TRICK(tt_ind));
end

plot(cumsum(pseudo_regret_UCB1),'LineWidth',2);
hold on;
plot(cumsum(pseudo_regret_TS),'LineWidth',2);
hold on;
plot(cumsum(pseudo_regret_SWTS),'LineWidth',2);
hold on;
plot(cumsum(pseudo_regret_SWUCB),'LineWidth',2);
hold on;
plot(cumsum(pseudo_regret_SWUCB_TRICK),'LineWidth',2);


legend({'UCB1 Regret' 'TS Regret' 'SW-TS Regret' 'SW-UCB Regret' 'SW-UCB-TRICK Regret'}, 'Location', 'NorthWest');
ylabel('Regret');
xlabel('t');
hold off;

%% Plot SW-UCB bounds and compare

const=5; % constant for the SW-UCB bound

UpperBound_SWUCB = const * sqrt(gamma * (1:T) .* log(1:T));
UpperBound_SWUCB_TRICK =  log2(1:T) .* sqrt(gamma * (1:T) .* log(1:T));

f1 = figure;
plot(1:T, UpperBound_SWUCB);
hold on;
plot(1:T, UpperBound_SWUCB_TRICK);
hold on;
plot(cumsum(pseudo_regret_SWUCB),'LineWidth',2);
hold on;
plot(cumsum(pseudo_regret_SWUCB_TRICK),'LineWidth',2);

legend({'Bound SW-UCB' 'Bound SW-UCB-TRICK' 'SW-UCB Regret' 'SW-UCB-TRICK Regret'}, 'Location', 'NorthWest');
title("SW-UCB comparison");

