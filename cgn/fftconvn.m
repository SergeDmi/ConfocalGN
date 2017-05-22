function C = fftconvn (A, B,shape)
% Copyright (C) 2015 Carnë Draug <carandraug@octave.org>
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation; either version 3 of the
% License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, see
% <http://www.gnu.org/licenses/>.

% -*- texinfo -*-
% @deftypefn  {Function File} {} fftconvn (@var{A}, @var{B})
% @deftypefnx {Function File} {} fftconvn (@var{A}, @var{B}, @var{shape})
% Convolve N dimensional signals using the FFT for computation.
%
% This function is equivalent to @code{convn} but using the FFT.  It
% convolves the two N dimensional @var{A} and @var{B}.  The size of
% output is controlled by the option @var{shape} which removes the
% borders where boundary effects may be seen:
%
% @table @asis
% @item @qcode{'full'} (default)
% Return the full convolution.
%
% @item @qcode{'same'}
% Return central part of the convolution with the same size as @var{A}.
%
% @item @qcode{'valid'}
% Return only the parts which do not include zero-padded edges.
%
% @end table
%
% Using the FFT may be faster but this is not always the case and can
% be a lot worse, specially for smalls @var{A} and @var{B}.  This performance
% increase also comes at the cost of increased memory usage, as well as a loss
% of precision.
%
% @example
% @group
% a = randi (255, 1024, 1024);
% b = randi (255, 10, 10);
% t = cputime (); convn (a, b); cputime () -t
%    @result{} 0.096000
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 1.2560
%
% b = randi (255, 50, 50);
% t = cputime (); convn (a, b); cputime () -t
%    @result{} 2.3400
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 1.2560
% @end group
% @end example
%
% Note how computation time for @code{convn} increased with the size of
% @var{B} but remained constant when using @code{fftconvn}.  When
% performing the convolution, @code{fftconvn} zero pads both @var{A} and
% @var{B} so their lengths are a power of two on all dimensions.
% This may further increase memory usage but will also increase
% performance.  In this example, the computation time will remain constant
% until @code{size (@var{A}) + size (@var{B}) -1} is greater than 2048
% after which it will remain constant again until it reaches 4096.
%
% @example
% @group
% a = randi (255, 1024, 1024);
% b = randi (255, 50, 50);
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 1.2760
% a = randi (255, 2048-50+1, 2048-50+1);
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 1.2120
% a = randi (255, 2049-50+1, 2049-50+1);
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 6.1520
% a = randi (255, 4096-50+1, 4096-50+1);
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 6.2360
% a = randi (255, 4097-50+1, 4097-50+1);
% t = cputime (); fftconvn (a, b); cputime () -t
%    @result{} 38.120
% @end group
% @end example
%
% @seealso{convn, fftconv2, fftconv, padarray}
% @end deftypefn

 if (nargin < 3)
     shape='full';
 end
     
  if (nargin < 2 || nargin > 3)
    print_usage ();
  elseif (~ isnumeric (A) || ~ isnumeric (B))
    error ('fftconvn: A and B must be numeric')
  end

  nd = max (ndims (A), ndims (B));
  A_size = get_sizes (A, nd);
  B_size = get_sizes (B, nd);
  fft_size = 2 .^ nextpow2 (A_size + B_size - 1);

  C = ifftn (fftn (A, fft_size(1:ndims(A))) .* fftn (B, fft_size(1:ndims(B))));
  if (~isreal (C) && isreal (A) && isreal (B))
    C = real (C);
  end

  switch (lower (shape))
    case 'full'
      starts  = repmat(1, [1 nd]);
      ends    = A_size + B_size - 1;
    case 'same'
      prepad  = floor (B_size / 2);
      starts  = prepad + 1;
      ends    = A_size + prepad;
    case 'valid'
      starts  = B_size;
      ends    = A_size;
    otherwise
      error ('fftconvn: unknown SHAPE');
  end

  if (any (starts > 1) || any (ends ~= fft_size))
    idx = get_ndim_idx (starts, ends);
    C = C(idx{:});
  end
end

% returns the size of x but padded with 1 (singleton dimensions), to
% allow operations to be performed when the ndims do not match
function sizes = get_sizes (x, n)
  sizes = postpad (size (x), n, 1, 2);
end

% starts and ends must have same length
function idx = get_ndim_idx (starts, ends)
  idx = arrayfun (@colon, starts, ends, 'UniformOutput', false);
end

%~function test_shapes (a, b, precision)
%~  shapes = {'valid', 'same', 'full'};
%~  for i = 1:3
%~    shape = shapes{i};
%~    assert (fftconvn (a, b, shape), convn (a, b, shape), precision);
%~  end
%~  assert (fftconvn (a, b), fftconvn (a, b, 'full'));
%~end

% simplest case
%~test test_shapes (randi (255, 100), randi (255, 10), 0.1)
%~test test_shapes (randi (255, 100, 100), randi (255, 10, 10), 0.1)
%~test test_shapes (randi (255, 100, 100, 100), randi (255, 10, 10, 10), 0.1)

% mix of number of dimensions
%~test test_shapes (randi (255, 100, 50, 20), randi (255, 10, 7), 0.1)
%~test test_shapes (randi (255, 100, 50, 20), randi (255, 10), 0.1)

% test near powers of 2 sizes
%~test
%~ for s = [55 56 57 58]
%~   test_shapes (randi (255, 200, 200), randi (255, s, s), 0.1)
%~ end
%~test
%~ for s = [203 204 205 206]
%~   test_shapes (randi (255, s, s), randi (255, 52, 52), 0.1)
%~ end

% test with other classes
%~test test_shapes (randi (255, 100, 100, 'uint8'), randi (255, 10, 10, 'uint8'), 0.1)
%~test test_shapes (randi (255, 100, 100, 'uint8'), randi (255, 10, 10), 0.1)
%~test test_shapes (randi (255, 100, 100, 'single'), randi (255, 10, 10, 'single'), 0.9)
%~test test_shapes (randi (255, 100, 100, 'single'), randi (255, 10, 10), 0.9)

