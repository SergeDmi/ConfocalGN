function [RR]=generate_bbseam(Npts,b,R,dt,angs)
if nargin<5
    angs=[0 0 0];
end

%dt=0.001;
RR=bbseam_points(b,dt);
M=rotmat_3D(angs);
RR=(R*M*RR')';
s=size(RR);
RR=RR+ones(s)*Npts/2;

end