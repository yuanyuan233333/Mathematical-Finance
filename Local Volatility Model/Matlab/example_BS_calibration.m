clc;
clearvars;

% market data
spot = 3706.01;
T = 56/365;
disc_fact = 0.9938;
fwd = 3717.6;

% model data
r = -log(disc_fact)/T;
q = -log(fwd*disc_fact/spot)/T;

% market price of a call option
K = 4000;
mkt_price = 48.6641;
impl_vol = blsimpv(fwd,K,0,T,mkt_price/disc_fact);

