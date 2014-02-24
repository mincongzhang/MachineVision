function res = logNormal( X, sigma, mu )
% TODO fill out this function
P = (1/sqrt(2*pi*sigma^2)) * exp( -0.5*sum(  ((X - mu).^2)/sigma^2  )  );
res = log(P);