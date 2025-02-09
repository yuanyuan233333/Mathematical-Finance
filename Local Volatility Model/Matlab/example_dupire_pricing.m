clc;
clearvars;

% spot
Spot = 3560;

% expiries of the LV matrix
T = [ 0.063 0.159 0.312 0.562 0.830 1.079 1.578 2.077 2.575 3.074 4.071 5.068];

% discount rates at LV expiries
r = [-0.0039 -0.0033 -0.0029 -0.0018 -0.0024 -0.0031 -0.0024 -0.0011 0.0022 0.005 0.005 0.0077];

% dividend yield at LV expiries
q = [-0.03 -0.01 -0.01 0 0 0.01 0.01 0.015 0.15 0.02 0.02 0.02];

% LV strikes
K = [
    0.92	0.86	0.80	0.72	0.66	0.62	0.55	0.51	0.46	0.42	0.34	0.28;
    0.97	0.97	0.94	0.91	0.89	0.87	0.84	0.83	0.80	0.78	0.75	0.72;
    0.98	0.98	0.98	0.96	0.97	0.96	0.94	0.93	0.93	0.91	0.91	0.88;
    0.99	1.00	1.00	0.99	1.00	1.00	1.00	1.01	1.00	1.01	1.01	1.00;
    1.01	1.01	1.01	1.02	1.04	1.04	1.06	1.07	1.08	1.09	1.10	1.11;
    1.02	1.02	1.04	1.07	1.08	1.10	1.13	1.16	1.19	1.22	1.28	1.33;
    1.04	1.07	1.11	1.15	1.20	1.23	1.33	1.40	1.50	1.60	1.77	1.95];

% LV matrix
V = [
    0.3129	0.4443	0.3646	0.4332	0.4405	0.3815	0.4093	0.3906	0.4563	0.4486	0.6495	0.7279;
    0.1864	0.1669	0.2070	0.2410	0.2368	0.2414	0.2474	0.2270	0.2358	0.2124	0.2250	0.2269;
    0.1520	0.1459	0.1641	0.1935	0.1908	0.2029	0.2088	0.2015	0.2104	0.2000	0.2095	0.2154;
    0.1241	0.1211	0.1474	0.1706	0.1706	0.1814	0.1870	0.1806	0.1933	0.1882	0.1955	0.2006;
    0.0911	0.0988	0.1387	0.1433	0.1432	0.1609	0.1633	0.1659	0.1767	0.1791	0.1847	0.1902;
    0.0798	0.0829	0.1083	0.1238	0.1295	0.1443	0.1499	0.1535	0.1668	0.1808	0.1832	0.1974;
    0.1014	0.0939	0.1189	0.1030	0.1141	0.1246	0.1426	0.1448	0.1755	0.2058	0.1965	0.2157];

% option data
expiry = 1.;
strike = 2500;

% solve dupire: find prices C of options with given expiry and strikes k
% normalized market strikes
Lt = 100; Lh = 1000; K_min = 0.01; K_max = 3.5; scheme = 'cn';
[ k, C ] = solve_dupire(T,K,V,expiry,Lt,Lh,K_min,K_max,scheme);

% normalized option price
fwd_at_expiry = forward(Spot,T,r,q,expiry);
norm_strike = strike/fwd_at_expiry;
norm_price = interp1(k,C,norm_strike);
model_impl_vol_1 = blsimpv(1,norm_strike,0,expiry,norm_price);

% option price
disc_fact_at_expiry = discount(T,r,expiry);
price = fwd_at_expiry * disc_fact_at_expiry * norm_price;
model_impl_vol_2 = blsimpv(fwd_at_expiry,strike,0,expiry,price/disc_fact_at_expiry);

