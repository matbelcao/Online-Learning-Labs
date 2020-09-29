function [d , labd] = generateCbSequence(N , a , alpha)
% N data points, uniform distribution,
% checkerboard with side a, rotated at alpha
d = rand(N , 2);
d_transformed = [d(: , 1) * cosd(alpha) - d(: , 2) * sind(alpha), d(: , 1) * sind(alpha) + d(: , 2) * cosd(alpha)];
s = ceil(d_transformed(: , 1) / a) + floor(d_transformed(: , 2) / a);
labd = 2 - mod(s , 2);


