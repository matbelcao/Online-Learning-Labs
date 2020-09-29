function ind = CDTUCB(reward, pulls, tt)

n_arms = size(reward, 2);
m = 30;
h = 7;
alpha = 0.01;
epsilon = 0.25;

persistent gplus
persistent gminus
persistent last_change
persistent bar_mu

if isempty(gplus)
    gplus = zeros(1, n_arms);
    gminus = zeros(1, n_arms);
    last_change = ones(1, n_arms);
    bar_mu = zeros(1, n_arms);
end

% Reset CDT if necessary
trigger = gplus > h | gminus > h;
if any(trigger)
    display("change detected")
    disp(trigger);
    index = find(trigger==1,1);
    
    last_change(index) = tt;
    gplus(index) = 0;
    gminus(index) = 0;
    bar_mu(index) = 0;
end

% Compute the pulls for each arm
avail_pulls = zeros(1, n_arms);
avail_reward = zeros(1, n_arms);
for ii = 1:n_arms
    avail_pulls(ii) = sum(pulls(last_change(ii):tt, ii));
    avail_reward(ii) = sum(reward(last_change(ii):tt, ii));
end

% Check if an arm has less than m pulls, if so pull it
less_than_m_pulls = (avail_pulls<m);
if any(less_than_m_pulls)
    ind = find(less_than_m_pulls > 0,1);
else
    % Compute bar_mu for all the arms having exactly m pulls
    %bar_mu(avail_pulls==m) = avail_reward(avail_pulls==m)/m;
    for ii = 1:n_arms
        if avail_pulls(ii) == m
            bar_mu(ii) = avail_reward(ii)/m;
        end
    end

    % Update the CDT using the last reward generated
    last_pulled = find(pulls(tt-1,:)==1,1);

    gplus(last_pulled) = max(0,gplus(last_pulled) + reward(tt-1,last_pulled) - bar_mu(last_pulled) - epsilon);
    gminus(last_pulled) = max(0,gminus(last_pulled) + bar_mu(last_pulled) - reward(tt-1,last_pulled) - epsilon);

    % Pull arms according to UCB with probability 1-\alpha
    if rand>alpha
        N = sum(pulls);
        %B = sqrt(log(tt-last_change) ./ N);
        n_t = sum (tt-last_change);
        B = sqrt(log(n_t) ./ N);
        hat_R = avail_reward ./ avail_pulls;
        U = min(1, hat_R + B);
        [~,ind] = max(U);
    else
        ind = randi([1 n_arms]);
    end
end
