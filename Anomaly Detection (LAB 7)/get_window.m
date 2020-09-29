function win_sec=get_window(HR)
a_low = [0.001890722251037  -0.454540542876902];
a_up = [-0.001566281984786   0.461443565583218];

win_sec = zeros(length(HR),2);
for ii=1:length(HR)
    win_sec(ii,:) = [a_low(1)*HR(ii)+a_low(2), a_up(1)*HR(ii)+a_up(2)];
end
