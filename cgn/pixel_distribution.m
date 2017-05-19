function [ px_distr ] = pixel_distribution(list_moments,NP,mode)
%Generating pixel distributions
%   list_moments is the moments of the pixels distribution
%   NP is the size of the array to be generated
%   mode is the type of distribution
if nargin<3
    mode='';
    if nargin<2
        NP=1;
    end
end

if length(NP)>1
    NP=prod(NP);
end

nm=length(list_moments);
if nm>=3
    if isempty(mode)
        mode='gamma';
    end
elseif nm==2
    if isempty(mode)
        mode='gamma';
    end
    if strcmp(mode,'gamma')
        list_moments(3)=0;
    end
elseif nm==1
    if isempty(mode)
        mode='poisson';
    end
end    

if strcmp(mode,'gamma')
    % Gamma or Gaussian distribution
    if list_moments(3)==0
        % if no skew, gaussian distribution
        px_distr=list_moments(1)+sqrt(list_moments(2))*box_muller();
    else
        % if skew, then Gamma distribution 
        [px_off,k,theta]=gamma_params(list_moments);
        if k<0 || theta<0
            % Not enough skew, back to gaussian distribution
            px_distr=list_moments(1)+sqrt(list_moments(2))*box_muller(NP);
        else
            px_distr=px_off+gamma_random(k,theta,NP);
        end 
    end
elseif strcmp(mode,'poisson')
    px_distr=poisson_rand(list_moments(1),NP);
else
    px_distr=ones(1,NP)*list_moments(1);
end

end

