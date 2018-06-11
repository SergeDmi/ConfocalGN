%% Super duper challenge : generate a confinement space to create a reference shape.

% Let's do a rectange : 

l=100;
w=100;

dw=50;
h=60;
pad=30;

Nx=3*l+2*pad;
Ny=w+dw+2*pad;
Nz=h+2*pad;


Img=zeros(Nx,Ny,Nz);

X=pad+(1:(3*l));
Y=pad+round([zeros(1,l),(1:l)*dw/l,dw+zeros(1,l)]);
Z=pad+zeros(1,3*l);

r=dw/l;
for i=1:l
    % first third
    Img(pad+i,pad:(pad+w),pad)=1.0;
    Img(pad+i,pad:(pad+w),pad+h)=1.0;
    Img(pad+i,pad,pad:(pad+h))=1.0;
    Img(pad+i,pad+w,pad:(pad+h))=1.0;
    % last third
    Img(2*l+pad+i,dw+(pad:(pad+w)),pad)=1.0;
    Img(2*l+pad+i,dw+(pad:(pad+w)),pad+h)=1.0;
    Img(2*l+pad+i,dw+pad,pad:(pad+h))=1.0;
    Img(2*l+pad+i,dw+pad+w,pad:(pad+h))=1.0;
    % second third
    Img(l+pad+i,(pad:(pad+w))+round(i*r),pad)=1.0;
    Img(l+pad+i,(pad:(pad+w))+round(i*r),pad+h)=1.0;
    Img(l+pad+i,pad+round(i*r),pad:(pad+h))=1.0;
    Img(l+pad+i,pad+w+round(i*r),pad:(pad+h))=1.0;
end

Img(pad,pad:(pad+w),pad:(pad+h))=1.0;
Img(3*l+pad,dw+pad:(pad+dw+w),pad:(pad+h))=1.0;
