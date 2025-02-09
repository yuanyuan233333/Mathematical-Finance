clc;
clearvars;

% spot
Spot = 3560;

% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.159 0.312 0.562 0.830 1.079 1.578 2.077 2.575 3.074 4.071 5.068];

% discount factor at market expiries
DiscFact = [1.000246 1.000563 1.001007 1.001457 1.002102 1.002875 1.004077 1.004628 1.003528 1.001028 0.996050 0.988433];

% forwards at market expiries
Fwd = [3565.86 3568.15 3572.03 3570.42 3568.12 3556.50 3534.57 3506.28 3257.47 3233.18 3185.19 3146.37];

% calibrate model parameters
[r,q] = calibrate_r_q(Spot,T,DiscFact,Fwd);

expiry = sort([T 0:0.5:7]);

model_fwd = zeros(1,length(expiry));
model_disc_fact = zeros(1,length(expiry));
for i=1:length(expiry)
    model_fwd(i) = forward(Spot,T,r,q,expiry(i));
    model_disc_fact(i) = discount(T,r,expiry(i));
end

% plot
figure;
plot(T,Fwd,'o',expiry,model_fwd);
title('Model forwards as a function of time');

figure;
plot(T,DiscFact,'o',expiry,model_disc_fact);
title('Model discount factors as a function of time');

