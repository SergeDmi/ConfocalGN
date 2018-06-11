%% Super duper challenge : generate a confinement space to create a reference shape.

% Let's do a rectange : 

L=300;
W=100;
H=30;

pad =30;
Nx=L+2*pad;
Ny=W+2*pad;
Nz=H+2*pad;

Img=zeros(Nx,Ny,Nz);


% Top & bottom
Img(pad:(pad+L),pad:(pad+W),pad)=1.0;
Img(pad:(pad+L),pad:(pad+W),H+pad)=1.0;
% Left and right
Img(pad:(pad+L),pad,pad:(pad+H))=1.0;
Img(pad:(pad+L),W+pad,pad:(pad+H))=1.0;
% Front and back
Img(pad,pad:(pad+W),pad:(pad+H))=1.0;
Img(L+pad,pad:(pad+W),pad:(pad+H))=1.0;

