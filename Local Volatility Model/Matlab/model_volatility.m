function [vol] = model_volatility(T,K_norm,V,Lt,Lh,K_min,K_max,Scheme)
% Compute model implied volatility of a local volatility model
% T.. LV expiries, K_norm.. LV strikes, V.. LV matrix
% Lt,Lh,K_min,K_max,Scheme.. settings for the Dupire solver
%
% vol(i,j).. model implied volatility at time T(i) and strike K_norm(i,j) 

[rows, cols] = size(K_norm);
vol = zeros(rows,cols);

for idx = 1:length(T)
    expiry = T(idx);
    [ k, C ] = solve_dupire( T, K_norm, V, expiry, Lt*idx, Lh, K_min, K_max, Scheme);
    price = interp1(k,C,K_norm(:,idx));
    vol(:,idx) = blsimpv(1,K_norm(:,idx),0,expiry,price);
end
end

