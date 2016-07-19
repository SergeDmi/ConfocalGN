function [img,pts]=generate_pts_img(Npts,RR,fluo,bkgd)
% Makes a 3D image from a set of points RR
% The image has size Npts x Npts x Npts
% Mean fluorophore fluorescence is fm, std dev is fd
% Mean background fluorescence is bm, std dev is bd
% S. Dmitrieff 2016

%% Default parameters
if nargin<4
    bkgd=[0 0 0];
    if nargin<3 
        fluo=[1 0 0];
    end
end
if length(bkgd)<3
    bkgd(3)=0;
end
if length(fluo)<3
    fluo(3)=0;
end

            
                
%% Initialization
sN=size(Npts);
if sN(2)==1;
    Npts=[Npts(1) Npts(1) Npts(1)];
end
img=zeros(Npts);
s=size(RR);
if s(1)==3
    RR=RR';
end

%% We select the points in the ground truth image the closest to the BBseam curve
% These points will have a 
A=unique(round(RR),'rows');
sA=size(A,1);
if fluo(3)==0
    % if no skew, gaussian noise
	sig=fluo(1)+sqrt(fluo(2))*box_muller(Npts(1)*Npts(2)*Npts(3));
else
    % if skew, then Gamma distribution 
    [px_off,k,theta]=gamma_params(fluo);
    if k<0 || theta<0
        % Not enough skew, back to gaussian noise
       	sig=fluo(1)+sqrt(fluo(2))*box_muller(Npts(1)*Npts(2)*Npts(3));
    else
        sig=px_off+gamrnd_simpl(k,theta,Npts(1)*Npts(2)*Npts(3));
    end
end
for t=1:sA
    img(A(t,1),A(t,2),A(t,3))=max(0,sig(t));
end
%% Adding the background
if bkgd(3)==0
    % if no skew, gaussian noise
	bg=bkgd(1)+sqrt(bkgd(2))*box_muller(Npts(1)*Npts(2)*Npts(3));
else
    % if skew, then Gamma distribution 
    [px_off,k,theta]=gamma_params(bkgd);
    if k<0 || theta<0
        % Not enough skew, back to gaussian noise
       	bg=bkgd(1)+sqrt(bkgd(2))*box_muller(Npts(1)*Npts(2)*Npts(3));
    else
        bg=px_off+gamrnd_simpl(k,theta,Npts(1)*Npts(2)*Npts(3));
    end
end
img(:)=img(:)+bg;
pts=A';

end