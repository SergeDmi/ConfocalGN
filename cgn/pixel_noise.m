function [ px_noise ] = pixel_noise(noise,nn)
%Generating the pixel noise 
%   noise is the moments of the background pixels distribution
%   nn is the size of the array to be generated

if noise(3)==0
    % if no skew, gaussian noise
	px_noise=noise(1)+sqrt(noise(2))*box_muller(nn(1)*nn(2)*nn(3));
else
    % if skew, then Gamma distribution 
    [px_off,k,theta]=gamma_params(noise);
    if k<0 || theta<0
        % Not enough skew, back to gaussian noise
       	px_noise=noise(1)+sqrt(noise(2))*box_muller(nn(1)*nn(2)*nn(3));
    else
        px_noise=px_off+gamma_random(k,theta,nn(1)*nn(2)*nn(3));
    end
end

end

