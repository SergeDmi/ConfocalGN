function [ Y ] = poisson_rand( l,N )
% Simple poisson random number generator
%   Implementing Knuth Algorithm
Y = zeros(N,1);
X = rand(N,1);
el=exp(-l);
cl=logical(X>=el);    
nl=sum(cl);

while nl>0
    X(cl)=X(cl).*rand(nl,1);
    Y(cl)=Y(cl)+1;
    cl=logical(X>=el);    
    nl=sum(cl);
end

end