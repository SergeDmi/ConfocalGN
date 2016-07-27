function [img,pts]=make_ground_truth()
% Make a ground truth
%   Here makes a baseball seam shape



%% PARAMETER for ground truth generation
% Properties of the fluorophores
%   gaussian fluorescence is assumed for all points in the original signal
%   This is VERY tough to estimate theoretically as it depends on the
%   number of fluorophores, exposure time, etc.
fluo=[1 0];
% Background fluorescence
bkgd=[0 0 0];
% Thickness of the curve 
d=9;
% Degree of coiling of the base ball seam curve
b=0.00;
% Orientation of the BBseam curve
angs=[0 pi/10 0];
% Radius of the sphere containing BB seam curve
R=112;
% Resolution 
dt=0.001;
% Size of the ground truth in discretized units
Npts=[552 552 162];
%% Generating a set of points ; here, a BBseam curve
RR=generate_bbseam(Npts,b,R,dt,angs);
%% Generating an image from these points
% Image includes fluorophore stochasticity and background fluorescence
[img,pts]=generate_pts_img(Npts,RR,d,fluo,bkgd);



end