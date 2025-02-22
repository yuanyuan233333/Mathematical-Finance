clc;
clearvars;

% expiries of the LV matrix
T = [1 2];

% discount factor at LV expiry
DF = [1 1]; 
r = [0 0];

% Spot
Spot = 1;

% forwards at LV expiries
Fwd = [1 1]; 
q = [0 0];

% LV strikes
K = [0.5 0.4; 
     1   1; 
     1.5 1.9];

% LV matrix
V = [0.2 0.2; 
     0.2 0.2; 
     0.2 0.2];

% option data
expiry = 2;
strike = 0.9;

% MC settings
N = 1000000; %MC simulations
M = 100; %timesteps

% MC simulation
S = lv_simulation_log(T,Spot,r,q,V,K,N,M,expiry);

% option price
discount_factor = 1; % = discount(T,r,expiry);
call_price = discount_factor*mean( max(S(1,:) - strike,0) );

% model implied volatility
fwd = 1; % = forward(T,r,q,expiry);
model_impl_vol = blsimpv(fwd,strike,0,expiry,call_price/discount_factor)
