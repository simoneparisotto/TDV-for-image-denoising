function a = idctt(b,nn,omega,FFTW)
%IDCTT Inverse discrete cosine transform
%   Specifically, a modified Type III DCT --
%   it computes an orthogonal DCT, 
%   i.e. IDCT = (DCT)^* = (DCT)^-1, where the 
%   foward DCT is modified Type II
%   Unless give the fftw argument (see below), this gives the same
%   result as calling matlab's IDCT
%
%   modified from IDCT (builtin matlab function) by Stephen Becker
%
%   X = IDCTT(Y) inverts the DCT transform, returning the
%   original vector if Y was obtained using Y = DCT(X).
%
%   X = IDCTT(Y,N) pads or truncates the vector Y to length N 
%   before transforming.
%
%   Y = IDCTT(X,N,OMEGA) uses Y = IDCTT(XX), where XX is a zero
%   vector (or matrix) of size N, and XX(OMEGA) = X
%   This is the inverse of DCTT(X,N,OMEGA), which is a sampled DCT.
%   You MUST supply the argument N for this case
%
%   Y = IDCTT(X,N,OMEGA,1) will return a Type III DCT using
%   the normalization coefficients from the fftw website
%   (and 2x the coefficients from the wikipedia definitions)
%   This version is NOT orthogonal.  It computes an
%   inverse to the forward DCT of fftw type II up to scaling, i.e.
%       DCT(IDCT) = IDCT(DCT) = 2n * I
%   where DCT and IDCT are DCTT and IDCTT, resp., with the fftw flag.
%   This is what fftw will compute (if you specify type III)
%   DCT and IDCT are no longer adjoints, i.e. DCT no longer othogonal.
%
%   Y = IDCTT(X,N,OMEGA,2) will return a Type III DCT
%   that is the ADJOINT of the forward DCT of fftw type II, i.e.
%       DCT = (IDCT)^*
%   Note that they are adjoints but not inverses
%   and DCT(IDCT) is a diagonal matrix, and IDCT(DCT) is a full matrix
%   Use N = [] and OMEGA = [] to ignore these parameters
%
%   If Y is a matrix, the IDCT operation is applied to
%   each column.
%
%   See also DCTT.

%   
%   This version is modified by Stephen Becker, 1/28/08
%   srbecker@caltech.edu
%   This version uses persistent variables to achieve
%   a more than 2x speed reduction on subsequent calls
%   On these subsequent calls, should be only about 
%   1.4 to 1.5x slower than a FFT,
%   instead of 4x slower (original matlab code)
%   On the first call, it's still faster than matlab's IDCT
%
%   Based off matlab's "idct" function, which was written by:
%              C. Thompson, 2-12-93
%              S. Eddins, 10-26-94, revised

persistent ww   % this is independent of any subsampling
persistent N

if nargin == 0,
	error('Not enough input arguments.');
end

if isempty(b),
   a = [];
   return
end

% If input is a vector, make it a column:
do_trans = (size(b,1) == 1);
if do_trans, b = b(:); end
   
[n,m] = size(b);
if nargin==1 || isempty(nn)
  nn = size(b,1);
end

% decide whether to recompute "ww" (which depends only on nn)
if isempty(N) || ( N ~= nn)
    RECOMPUTE = true;
    N = nn;
else
    RECOMPUTE = false;
end

% Look at inputs and decide whether to subsample
if nargin > 2 && ~isempty(omega)
    SUBSAMPLE = true;
else
    SUBSAMPLE = false;
end

% Pad or truncate b if necessary
if n<nn,
  bb = zeros(nn,m);
  if SUBSAMPLE
      bb(omega,:) = b;
  else
      bb(1:n,:) = b;
  end
elseif n==nn
  bb = b;
else
  bb = b(1:nn,:);
end
n = nn;

if nargin > 3 && FFTW
% If requested, convert to fftw conventions
%   FFTW = 1 computes the Inverse DCT, up to a constant of 2*n
%   FFTW = 2 computes the Adjoint DCT
% For all except the DC component (k=0),
%   multiply by sqrt(n/2)
% For the DC component, multiply by just sqrt(n)
    if FFTW == 2   sqrtn = 2*sqrt(n);
    else           sqrtn =   sqrt(n);
    end
    sqrtn2 = sqrt(2*n);
    if m == 1   % break into subcases for speed
        bb(2:end) = sqrtn2 * bb(2:end);
        bb(1) = sqrtn * bb(1);
    else
        bb(2:end,:) = sqrtn2 * bb(2:end,:);
        bb(1,:) = sqrtn * bb(1,:);
    end
end

odd =  ( rem(n,2)==1 || ~isreal(b) );

% Compute weights with persistent variables
if RECOMPUTE
    c = j*pi/(2*n);
    ww = sqrt(2*n) * exp( c*(0:n-1) ).';
    if odd
       ww(1) = ww(1) * sqrt(2);
    else
       ww(1) = ww(1)/sqrt(2);
    end
end

if odd
  % Form intermediate even-symmetric matrix.
  if m == 1
      W = ww; % matlab is smart enough NOT to perform a copy here
  else
      W = ww(:,ones(1,m));   % MAKE THIS INTO A REPMAT CALL?
      % Note to user: if you repeatedly call this function
      % with a *matrix* argument "b", then you might want to make
      % "W", not just "w", a persistent variable, if you can afford
      % the memory.
  end
  
  % most of the code below here is identical to the matlab version
  yy = zeros(2*n,m);
  yy(1:n,:) = W.*bb;
  yy(n+2:2*n,:) = -j*W(2:n,:).*flipud(bb(2:n,:));
  
  y = ifft(yy);

  % Extract inverse DCT
  a = y(1:n,:);

else
  if m == 1
      yy = ww.*bb;
  else
      W = ww(:,ones(1,m));
      yy = W.*bb;
  end

  % Compute x tilde using equation (5.93) in Jain
  y = ifft(yy);
  
  % Re-order elements of each column according to equations (5.93) and
  % (5.94) in Jain
  a = zeros(n,m);
  a(1:2:n,:) = y(1:n/2,:);
  a(2:2:n,:) = y(n:-1:n/2+1,:);
end

if isreal(b), a = real(a); end
if do_trans, a = a.'; end