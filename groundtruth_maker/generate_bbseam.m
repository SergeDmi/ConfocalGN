function [RR]=generate_bbseam(b,R,dt,angs)
% Generates a baseball seam curve in a 
%   Npts should be a 1x3 vector or a scalar
%   b is the degree of coiling
%   R is the radius of the sphere containing the bb seam
%   dt is the interval between two points (should be <<1)
%   angs is the 3D rotation applied to the BBseam (default [0 0 0])

% Parameter checking
if nargin<4
    angs=[0 0 0];
end

%% Making the BBseam
RR=bbseam_points(b,dt);
% rotation & scaling
M=rotmat_3D(angs);
RR=(R*M*RR')';

end