function [img]=generate_image(Sizes,RR,fluo,bkgd,mode)
% Makes a 3D image from a set of points RR
%  The image has size Sizes(1) x Sizes(2) x Sizes(3)
% The fluorescence has moments fluo
% Background fluorescence has moments bkgd
% mode is the mode of fluorophore stochasticity (poisson, gamma, or constant)
% S. Dmitrieff 2016


%% Default parameters
if nargin<5
    mode='';
end
        
if length(bkgd)<3
    bkgd(3)=0;
end

                         
%% Initialization
sN=size(Sizes);
if sN(2)==1;
    Sizes=[Sizes(1) Sizes(1) Sizes(1)];
end
img=zeros(Sizes);
s=size(RR);
NS=s(1);
sig=pixel_distribution(fluo,NS,mode);

%% Summing the fluorescence to each voxel
% We count the fluorophores per high-res voxel and add the fluorescence to
% the image
[A,~,toA]=unique(round(RR),'rows');
nA=size(A,1);
sigA=zeros(1,nA);

% Heuristic to save time in fluorescence assignement
if nA<4*NS
    for i=1:nA
        sigA(i)=sigA(i)+sum(sig(logical(toA==i)));
    end
else
    for i=1:NS
       sigA(toA(i))=sigA(toA(i))+sig(i);
    end
end
img(A(:,1)+(A(:,2)-1)*Sizes(1)+(A(:,3)-1)*Sizes(1)*Sizes(2))=sigA(:);

%% Adding the background
% Added to every points
if bkgd(3)==0
    % if no skew, gaussian noise
	bg=bkgd(1)+sqrt(bkgd(2))*box_muller(Sizes(1)*Sizes(2)*Sizes(3));
else
    % if skew, then Gamma distribution 
    [px_off,k,theta]=gamma_params(bkgd);
    if k<0 || theta<0
        % Not enough skew, back to gaussian noise
       	bg=bkgd(1)+sqrt(bkgd(2))*box_muller(Sizes(1)*Sizes(2)*Sizes(3));
    else
        bg=px_off+gamma_random(k,theta,Sizes(1)*Sizes(2)*Sizes(3));
    end
end
img(:)=img(:)+bg;

end