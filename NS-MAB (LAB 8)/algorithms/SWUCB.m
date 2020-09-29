function ind = SWUCB(reward, pulls, tt, T, gamma)

win_size = round(2*sqrt((T*log(T))/gamma));
xi = 0.5;

if tt > win_size
    N = sum(pulls((tt-win_size+1):tt,:));
    cum_r = sum(reward((tt-win_size+1):tt,:));
    B = sqrt(xi * log(win_size) ./ N);
else
    N = sum(pulls);
    cum_r = sum(reward);
    B = sqrt(xi * log(tt) ./ N);
end

hat_R = cum_r ./ N;

if tt <= length(cum_r)
    ind = tt;
else
    U = min(1, hat_R + B);
    
    [~, ind] = max(U);
end
