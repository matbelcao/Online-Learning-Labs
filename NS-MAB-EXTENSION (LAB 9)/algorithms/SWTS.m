function ind = SW_TS(rew, pulls, t, T)

win_size = round(sqrt(T));

if t > win_size
    N = sum(pulls((t-win_size+1):t,:));
    cum_r = sum(rew((t-win_size+1):t,:));
else
    N = sum(pulls);
    cum_r = sum(rew);
end
    
theta = betarnd(cum_r+1,N-cum_r+1); % alpha and beta
[~, ind] = max(theta);