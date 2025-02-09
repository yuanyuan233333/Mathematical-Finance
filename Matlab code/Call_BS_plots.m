%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the European Call Option Price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Variables
% s: integration variable for cumulated normal dist.
% Ttm: time-to-maturity of the derivative (T-t) 
% S: spot price of the underlyong asset
syms s Ttm S          

K = 100;            % Option strike (dollars)
r = 0.25;           % Risk-free rate (annualized)
%r = 0.0;
sigma = 0.80;       % Return volatility of the stock (annualized)

PV_K = K*exp(-r*Ttm);
d1 = (log(S/K) + (r + sigma^2/2)*Ttm)/(sigma*sqrt(Ttm));
d2 = d1 - sigma*sqrt(Ttm);
Nd1 = int(exp(-((s)^2)/2),-Inf,d1)*1/sqrt(2*pi);
Nd2 = int(exp(-((s)^2)/2),-Inf,d2)*1/sqrt(2*pi);
C = Nd1*S - Nd2*PV_K;

fsurf(C,[100 140 0. 0.50])
xlabel('Spot price')
ylabel('T-t (y. frac.)')
zlabel('Call option price')