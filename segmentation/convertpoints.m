function [ Pts,W ] = convertpoints( img , pixsizes,offset)
% Convert a 1D/2D/3D stack into an array of points coordinates Pts with
% weights W
%   Pixsizes corresponds to the pixel size along each dimension
%   Offset is the an offset 
%  
% Serge Dmitrieff, EMBL, 2015
if nargin<3
    offset=[0 0 0];
    if nargin<2
        pixsizes=[1 1 1];
    end
end
s=size(img);
l=length(pixsizes);

if length(s)==l && length(s)<4
   	ixes=logical(~isnan(img(:)))';
	if l==1
        % 1D
		X=pixsizes(1)*(1:s(1));
		Pts=X(ixes);
		W=img(ixes);
    else
		XX=pixsizes(1)*((1:s(1))')*ones(1,s(2));
		YX=pixsizes(2)*ones(s(1),1)*(1:s(2));
		if l==2
            % 2D
			Pts=[XX(ixes);YX(ixes)];
			W=img(ixes);
        else
            % 3D
            % This is the fastest I found : generate arrays X Y Z
            % X Y Z have a the size of the stack
            % X(n) corresponds to the X coordinate of the point n in the
            % stack 
            % Please let me know if there is faster !
			X=repmat(XX,[1,1,s(3)]);
			Y=repmat(YX,[1,1,s(3)]);
			ZX=pixsizes(3)*ones(s(2),1)*(1:s(3));
			Z=permute(repmat(ZX,[1,1,s(1)]),[3,1,2]);
			Pts=[X(ixes);Y(ixes);Z(ixes)];
			W=img(ixes);
		end
	end
else
    if length(s)~=l
        error('Pix size dimension not matching img dimension')
    end
	error('Too many dimensions')
end
n=length(W);
Pts=Pts+(ones(n,1)*offset)';

end

