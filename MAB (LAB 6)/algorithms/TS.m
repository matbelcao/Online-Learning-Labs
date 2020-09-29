function ind = TS(cum_r, N, t)

    persistent alpha beta prev_cum_r prev_ind

    % prev_cum_r: the old cumulative reward of the i-th arm
    % prev_ind: the index i of the arm played during the last round
    
    if  t==1
        % initialize variables for first iteration 
        alpha = ones(numel(N),1);
        beta = ones(numel(N),1);
        prev_cum_r = 0;
        prev_ind = 0;
    else
        % update last played action alpha-beta statistics
        if  cum_r(prev_ind) > prev_cum_r
            % SUCCES: the average reward of the last i-th played arm is 
            %         increased wrt the old reward average
            alpha(prev_ind) = alpha(prev_ind)+1;
        else
            beta(prev_ind) = beta(prev_ind)+1;
        end
    end
    
    theta = betarnd(alpha,beta);
    [~,ind] = max(theta);
    prev_ind = ind;

    prev_cum_r = cum_r(prev_ind);
    
    
    
    
    
    