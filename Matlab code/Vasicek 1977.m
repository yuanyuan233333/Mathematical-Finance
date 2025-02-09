%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple Vasicek 1977 Model                                               %
% See Bjork 4th Ed. Ch. 21                                                %
% AN 25/11/2024                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make plots visible also to students sitting in the last row
set(0,'defaultAxesFontSize',16)

%% Pricing functions
p = @(y,t,T) exp(-y.*(T-t));             % Zero coupon price
y = @(p,t,T) - log(p)./(T-t);            % Zero coupon yield

%% Affine term structure factors (see Bjork 4th Ed. Proposition 21.4)
B = @(a,tau) (1-exp(-a.*tau))/a;
A = @(a,b,s,tau) (B(a,tau)-tau).*(a*b-0.5*s^2)./(a^2) - 0.25.*(s^2).*(B(a,tau).^2)./a;

%% Vasicek model parameters

% Simple curve with positive slope
r0 = 0.05;
theta = 0.07;
a = 0.1;
% a = 1;        % Test a faster convergence to the mean
b = a*theta;
sigma = 0.02;

% Curve with negative slope
% r0 = 0.05;
% theta = 0.03;
% a = 0.05;
% b = a*theta;
% sigma = 0.02;

% Curve with hump
% r0 = 0.05;
% theta = 0.06;
% a = 0.05;
% b = a*theta;
% sigma = 0.02;

%% Linear model explained by some plots
t = 0;
Tmin = 1/12;            %From one month...
Tmax = 10;              %...to ten years...
nStep = 120;            %...at monthly steps
ZC_nodes  = linspace(Tmin,Tmax,nStep);

r_mean = r0 .* exp(-a*ZC_nodes) + theta .* (1-exp(-a*ZC_nodes));
r_var = sigma^2 .* (1-exp(-2*a*ZC_nodes))/(2*a);

% Plot expected short rate
figure
plot(ZC_nodes,r_mean,'Linewidth', 2,'LineStyle','-')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('expected short-rate')
xlabel('Time (year frac)')

%% Plot standard deviation of the short rate
figure
plot(ZC_nodes,sqrt(r_var),'Linewidth', 2,'LineStyle','-')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('standard deviation of the short rate')
xlabel('Time (year frac)')

%% Mean-reverting model explained by some plots
Dt = Tmax/nStep;
rate = zeros(1,nStep+1);
rate(1) = r0;

% Generate nStep standard 1-d normal variables stored to z(1,nStep)
z = randn(1,nStep);

% Sample path of the short rate
r = rate(1);
for i = 1:nStep
    mean = exp(-a*Dt)*r + theta .* (1-exp(-a*Dt));  %...must stay in the for loop...
    variance = sigma^2 * (1-exp(-2*a*Dt))/(2*a);    %...could get out the for loop!
    r = mean + sqrt(variance)*z(i);
    rate(i+1)=r;
end

% For comparison: path of an asset price (B&S 1976 model)
S = 1;
mu = theta;
price = zeros(1,nStep+1);
price(1) = S;
for i = 1:nStep
    mean =  mu*Dt - 0.5 * sigma^2;  %...could get out the for loop!
    variance = sigma^2 ;            %...could get out the for loop!
    S = S * exp(mean + sqrt(variance)*z(i));
    price(i+1)=S;
end

% Plot sample path of the short rate
figure
plot(ZC_nodes,rate(2:nStep+1),'x','Linewidth', 2,'LineStyle','-')
hold on;
plot(ZC_nodes,ones(nStep)*theta,'Linewidth', 2,'LineStyle','-')
hold off;
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Sample path of the short rate')
xlabel('Time (year frac)')

% Plot sample path of the asset price
figure
plot(ZC_nodes,price(2:nStep+1),'x','Linewidth', 2,'LineStyle','-')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Sample path of the asset price')
xlabel('Time (year frac)')

%% Affine model explained: term structure of the Zero-Coupon bond prices
A_vec = A(a,b,sigma,ZC_nodes);
B_vec = B(a,ZC_nodes);
ZC_prices = exp(A_vec - B_vec.*r0);
ZC_rates = y(ZC_prices,t,ZC_nodes)*100;
pCurve = [ZC_nodes;ZC_prices]'; 
zCurve = [ZC_nodes;ZC_rates]'; 

%% Instantaneous forwards curve
% For reference (general term structure)
% fwd_rates = -df(ZC_nodes,log(ZC_prices))*100; 

% Affine term structure (numerical derivative... ...lazy developer!)
fwd_rates = -df(ZC_nodes,A_vec - B_vec.*r0)*100; 
fCurve = [ZC_nodes;fwd_rates]';        

%% Plot curves
figure
plot(zCurve(:,1),zCurve(:,2),'Linewidth', 2,'LineStyle','-')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Zero Coupon Curve')
xlabel('Time (year frac)')

figure
plot(pCurve(:,1),pCurve(:,2),'Linewidth', 2,'LineStyle','-')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Zero Coupon bond prices')
xlabel('Time (year frac)')

figure
plot(fCurve(:,1),fCurve(:,2),'Linewidth', 2,'LineStyle','-')
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Instantaneous Forward Curve')
xlabel('Time (year frac)')
