clc;
clearvars;

% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.159 0.312 0.562 0.830 1.079 1.578 2.077 2.575 3.074 4.071 5.068];

% forwards at market expiries
Fwd = [3569.94 3563.83 3556.12 3473.93 3463.98 3446.99 3352.65 3329.88 3241.51 3225.23 3131.97 3053.65];

% market strikes
K = [
    3300	3050	2850	2500	2300	2150	1850	1700	1500	1350	1050	850;
    3450	3450	3350	3150	3100	3000	2800	2750	2600	2500	2350	2200;
    3500	3500	3500	3350	3350	3300	3150	3100	3000	2950	2850	2700;
    3550	3550	3550	3450	3450	3450	3350	3350	3250	3250	3150	3050;
    3600	3600	3600	3550	3600	3600	3550	3550	3500	3500	3450	3400;
    3650	3650	3700	3700	3750	3800	3800	3850	3850	3950	4000	4050;
    3700	3800	3950	4000	4150	4250	4450	4650	4850	5150	5550	5950];

% market implied volatilities
MktVol = [
    0.1876	0.2321	0.2370	0.2639	0.2763	0.2778	0.2859	0.2852	0.2943	0.3003	0.3285	0.3483;
    0.1438	0.1389	0.1619	0.1841	0.1897	0.1974	0.2058	0.2046	0.2086	0.2098	0.2131	0.2180;
    0.1296	0.1280	0.1411	0.1620	0.1663	0.1740	0.1834	0.1860	0.1895	0.1913	0.1953	0.2008;
    0.1156	0.1173	0.1344	0.1512	0.1574	0.1630	0.1717	0.1742	0.1794	0.1816	0.1876	0.1928;
    0.1021	0.1072	0.1279	0.1410	0.1449	0.1529	0.1611	0.1659	0.1707	0.1751	0.1817	0.1872;
    0.0935	0.0991	0.1163	0.1282	0.1348	0.1414	0.1506	0.1560	0.1617	0.1676	0.1753	0.1823;
    0.0934	0.0930	0.1073	0.1119	0.1179	0.1243	0.1357	0.1416	0.1510	0.1620	0.1712	0.1807];

% normalized market strikes
[rows, cols] = size(K);
K_norm = K ./ repmat(Fwd, rows, 1);

% Dupire solver settings
Lt = 10;
Lh = 200;
K_min = 0.1;
K_max = 3;
Scheme = 'cn';

% calibration settings
Threshold = 0.0010;
MaxIter = 100;

[V, ModelVol, MaxErr] = calibrator(T,K_norm,MktVol,Threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme);

% plot local volatility function vs market implied volatility
figure;
plot(K(:,1),MktVol(:,1),'o',K(:,1),ModelVol(:,1),':.',K(:,1),V(:,1),':.b','linewidth',1.5);
title('Calibrated model and local volatility for asset E CORP');
legend('MktVol','ModelVol','LocalVol')

figure;
plot(MaxErr,'.','MarkerSize',15);
title('calibration error at each iteration of the fixed-point calibration');

