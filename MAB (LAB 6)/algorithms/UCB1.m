function ind = UCB1(cum_r, N, t)
    
    % Average reward
    g_t = cum_r./N;
    g_t(N==0) = 0; % set = 0 to avoid NaN elements
    
    % Exploration factor
    b_t = sqrt((2*log(t))./N);
    b_t(N==0) = Inf; % set to infinite to let exploring the arm the first time
    
    u_t = g_t + b_t;
    
    [~,ind] = max(u_t);

