function [img,pts]=make_ground_truth(fname)
% Make a ground truth image, i.e. an isotropic high resolution 3D image
%   Here we make a baseball seam shape
%   This function is for demonstration purposes
%   Pipeline : parameters > points > image

if nargin < 1
    fname='ground_truth.tiff';
end

%% PARAMETER for ground truth generation
% Properties of the fluorophores
%   gaussian fluorescence is assumed for all points in the original signal
%   This is VERY tough to estimate theoretically as it depends on the
%   number of fluorophores, exposure time, etc.
fluo=[1 0];
% Background fluorescence (moments of the distribution)
bkgd=[0 0 0];
% Thickness of the curve (in pixels)
d=9;
% Degree of coiling of the base ball seam curve (0:ring)
b=0.00;
% Orientation of the BBseam curve
angs=[0 pi/10 0];
% Radius of the sphere containing BB seam curve (in pixels)
R=112;
% Resolution 
dt=0.001;
% Size of the ground truth in discretized units
Npts=[552 552 162];

%% Generating a set of points ; here, a BBseam curve
% Any function generating a set of points could work here
RR=generate_bbseam(Npts,b,R,dt,angs);

%% Generating an image from these points
% From an array of points in 3D we generate the corresponding image 
% Image includes fluorophore stochasticity and background fluorescence
[img,pts]=generate_pts_img(Npts,RR,d,fluo,bkgd);
%img=double(img);
%save_to_tiff(img,'ground_truth.tiff');
saveastiff(img,fname);

end