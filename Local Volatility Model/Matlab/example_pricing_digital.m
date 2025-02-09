clc;
clearvars;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MARKET DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.159 0.312 0.562 0.830 1.079 1.578 2.077];

% Spot
Spot = 3573.22;

% forwards at market expiries
Fwd = [3569.94 3563.83 3556.12 3473.93 3463.98 3446.99 3352.65 3329.88];

% discount factor at market expiry
DF = [1.0002428 1.0005586 1.0010088 1.0014682 1.0022950 1.0030480 1.0042523 1.0048028];

% market strikes
K = [
    3300	3050	2850	2500	2300	2150	1850	1700;
    3450	3450	3350	3150	3100	3000	2800	2750;
    3500	3500	3500	3350	3350	3300	3150	3100;
    3550	3550	3550	3450	3450	3450	3350	3350;
    3600	3600	3600	3550	3600	3600	3550	3550;
    3650	3650	3700	3700	3750	3800	3800	3850;
    3700	3800	3950	4000	4150	4250	4450	4650];

% market volatilities
MktVol = [
    0.1876	0.2321	0.2370	0.2639	0.2763	0.2778	0.2859	0.2852;
    0.1438	0.1389	0.1619	0.1841	0.1897	0.1974	0.2058	0.2046;
    0.1296	0.1280	0.1411	0.1620	0.1663	0.1740	0.1834	0.1860;
    0.1156	0.1173	0.1344	0.1512	0.1574	0.1630	0.1717	0.1742;
    0.1021	0.1072	0.1279	0.1410	0.1449	0.1529	0.1611	0.1659;
    0.0935	0.0991	0.1163	0.1282	0.1348	0.1414	0.1506	0.1560;
    0.0934	0.0930	0.1073	0.1119	0.1179	0.1243	0.1357	0.1416];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALIBRATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calibrate r,q
[r,q] = calibrate_r_q(Spot,T,DF,Fwd);

% normalized market strikes
[rows, cols] = size(K);
K_norm = K ./ repmat(Fwd, rows, 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRICING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% option data
expiry = 1.079;
strike = 3600;

% Static-replica price of a digital option;
eps = 0.01;
time_idx = find(T>=expiry,1);
sigma_m = interp1(K(:,time_idx),MktVol(:,time_idx),strike*(1-0.5*eps));
sigma_p = interp1(K(:,time_idx),MktVol(:,time_idx),strike*(1+0.5*eps));
discount_factor = discount(T,r,expiry);
pr_m = discount_factor*blsprice(Fwd(time_idx),strike*(1-0.5*eps),0,T(time_idx),sigma_m,0);
pr_p = discount_factor*blsprice(Fwd(time_idx),strike*(1+0.5*eps),0,T(time_idx),sigma_p,0);
price_replica = (pr_m - pr_p) / (strike*eps);

% Black price of a digital option;
sigma = interp1(K(:,time_idx),MktVol(:,time_idx),strike);
pr_m = discount_factor*blsprice(Fwd(time_idx),strike*(1-0.5*eps),0,T(time_idx),sigma,0);
pr_p = discount_factor*blsprice(Fwd(time_idx),strike*(1+0.5*eps),0,T(time_idx),sigma,0);
price_black = (pr_m - pr_p) / (strike*eps);

