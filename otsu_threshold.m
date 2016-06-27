function [t] = otsu_threshold(Image)
%Intuition:
%(1)pixels are divided into two groups
%(2)pixels within each group are very similar to each other 
%   Parameters:
%   t : threshold 
%   r : pixel value ranging from 1 to 255
%   q_L, q_H : the number of lower and higher group respectively
%   sigma : group variance
%   miu : group mean
%   Author: Lei Wang
%   Date  : 22/09/2013
%   References : Wikepedia, 
%   for multi children Otsu method, please visit : https://drive.google.com/file/d/0BxbR2jt9XyxteF9fZ0NDQ0dKQkU/view?usp=sharing
nbins = 256;
[counts ,centers]= hist(Image(:),nbins);
p = counts / sum(counts);
sigma_b=zeros(1,nbins);

for t = 1 : nbins
   q_L = sum(p(1 : t));
   q_H = sum(p(t + 1 : end));
   miu_L = sum(p(1 : t) .* (1 : t)) / q_L;
   miu_H = sum(p((t + 1):end).*((t + 1):nbins))/q_H;
   sigma_b(t) = q_L * q_H * (miu_L - miu_H)^2;
end
[~,threshold_otsu] = max(sigma_b(:));
t=centers(ceil(threshold_otsu));
end

