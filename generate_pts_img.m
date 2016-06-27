function [img,pts]=generate_pts_img(Npts,RR,fm,fd,bm,bd)
% Makes a 3 image from a set of points RR
% The image has size Npts x Npts x Npts
% Mean fluorophore fluorescence is fm, std dev is fd
% Mean background fluorescence is bm, std dev is bd
% S. Dmitrieff 2016

%% Default parameters
if nargin<6
    bd=0;
    if nargin<5 
        bf=0;
        if nargin <4
            fd=0;
            if nargin < 3
                fm=1;
            end
        end
    end
end
            
                
%% Initialization
img=zeros(Npts,Npts,Npts);
s=size(RR);
if s(1)==3
    RR=RR';
end



%% We take the points in the image the closest to points in RR
A=unique(round(RR),'rows');
sA=size(A,1);
sig=fd*box_muller(sA);
for t=1:sA
    img(A(t,1),A(t,2),A(t,3))=max(0,fm+sig(t));
end
%% Adding the background
img(:)=img(:)+(bm+bd*box_muller(Npts^3));
pts=A';
end