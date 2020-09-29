function scut = cut_signal(s,hr_low,hr_high,fs)

win_base = get_window(hr_low);
win_target = get_window(hr_high);

s_win_base = round(win_base*fs);
s_win_target = round(win_target*fs);

i_begin = s_win_target(1)-s_win_base(1)+1;
i_end = s_win_target(2)-s_win_base(1)+1;

scut = s(i_begin:i_end,:);



