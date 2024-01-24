function [Threshold, ChangeT] = CalAccThreshold(Acceleration, Threshold)
ChangeT = 10000;
N_Threshold = Threshold;

while ChangeT >= 1
Threshold = N_Threshold;

m = nanmean(abs(Acceleration(find(abs(Acceleration) < Threshold),1)));
sd = nanstd(abs(Acceleration(find(abs(Acceleration) < Threshold),1)));
N_Threshold = m + 6 * sd;
clear m sd

ChangeT = (Threshold - N_Threshold);
end