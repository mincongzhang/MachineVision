function res = normal( X, sigma, mu )
% TODO fill out this function
P = (1/((2*pi*sigma^2)^(length(X)/2))) * exp( -0.5*sum(  ((X - mu).^2)/sigma^2  )  );
res = P;