function ind = SWUCB_TRICK(reward, pulls, tt, k, gamma)

n_arms = size(reward, 2);
low = 2^k;
up = 2^(k+1);
phase = up - low;

win_size = round(2*sqrt((phase*log(phase))/gamma));
xi = 0.5;

if (tt) == low
   %fprintf("\nSW-UCB-TRICK(tt=%d): starting new phase %d --> %d  win_size=%d ",tt,low,up,win_size);
end

if (tt-low) > win_size
    N = sum(pulls((tt-win_size+1):tt,:));
    cum_r = sum(reward((tt-win_size+1):tt,:));
    B = sqrt(xi * log(win_size) ./ N);
else
    N = sum(pulls((low):tt,:));
    cum_r = sum(reward((low):tt,:));
    B = sqrt(xi * log(tt-low) ./ N);
end

hat_R = cum_r ./ N;

for ii = 1:n_arms
    avail_pulls(ii) = sum(pulls(low:tt, ii)); % compute arm pulls in the phase
end
arms_zero_pull = (avail_pulls<1);

if any(arms_zero_pull) %explore untaken arms
    ind = find(arms_zero_pull > 0,1);
else
    U = min(1, hat_R + B);
    
    [~, ind] = max(U);
end
