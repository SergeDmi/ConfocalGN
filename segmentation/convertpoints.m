function [ Pts,W ] = convertpoints( img , pixsizes,offset)
% Convert a 1D to 3D stack into a cloud of weighted points
%   Pixsizes correspont to the pixel size along each dimension
%  
% Serge Dmitrieff, EMBL, 2015
if nargin<3
    offset=[0 0 0];
end
s=size(img);
l=length(pixsizes);

if length(s)==l && length(s)<4
    %ix=(1:numel(img));
    %ixes=ix(~isnan(img(:)))';
   	ixes=logical(~isnan(img(:)))';
    %ixes=ix(ixes);
	if l==1
		X=pixsizes(1)*(1:s(1));
		%np=sum(ixes);
		Pts=X(ixes);
		W=img(ixes);
    else
		XX=pixsizes(1)*((1:s(1))')*ones(1,s(2));
		YX=pixsizes(2)*ones(s(1),1)*(1:s(2));
		if l==2
			Pts=[XX(ixes);YX(ixes)];
			W=img(ixes);
		else
			X=repmat(XX,[1,1,s(3)]);
			Y=repmat(YX,[1,1,s(3)]);
			ZX=pixsizes(3)*ones(s(2),1)*(1:s(3));
			Z=permute(repmat(ZX,[1,1,s(1)]),[3,1,2]);
			Pts=[X(ixes);Y(ixes);Z(ixes)];
			W=img(ixes);
		end
	end
else
	Pts=[];
	W=[];
end

n=length(W);
Pts=Pts+(ones(n,1)*offset)';


end

