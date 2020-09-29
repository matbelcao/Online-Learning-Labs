function ind = SWUCB(reward, pulls, tt, T, gamma)

n_arms = size(reward, 2);
win_size = round(2*sqrt((T*log(T))/gamma));
xi = 0.5;

if tt > win_size
    N = sum(pulls((tt-win_size+1):tt,:));
    cum_r = sum(reward((tt-win_size+1):tt,:));
    B = sqrt(xi * log(win_size) ./ N);
    
    for ii = 1:n_arms
        avail_pulls(ii) = sum(pulls(tt-win_size+1:tt, ii)); % compute arm pulls in the window
    end
else
    N = sum(pulls);
    cum_r = sum(reward);
    B = sqrt(xi * log(tt) ./ N);
    
    for ii = 1:n_arms
        avail_pulls(ii) = sum(pulls(:,ii)); % compute arm pulls in the window
    end
end

hat_R = cum_r ./ N;

arms_zero_pull = (avail_pulls<1);

if any(arms_zero_pull) %explore untaken arms
    ind = find(arms_zero_pull > 0,1);
else
    U = min(1, hat_R + B);
    
    [~, ind] = max(U);
end
