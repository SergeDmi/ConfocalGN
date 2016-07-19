function [ offset, k , theta ] = gamma_params(M)
% gamma_params extract gamma function params from moments M
%   M is a 3x1 vector containing the 3 first moments of a distribution
%   M is fitted to a distribution offset + gamma(k, theta)
%
% Serge Dmitrieff, EMBL, 2016
% www.biophysics.fr

theta=0.5*M(3)/M(2);
k=M(2)/(theta^2);
offset=M(1)-k*theta;

end

