%{
Matlab code downloaded from:
https://sethares.engr.wisc.edu/vocoders/matlabphasevocoder.html
%}

function peaks = findPeaks4( Amp, MAX_PEAK, EPS_PEAK, SSF )

%   This version modified from findPeaks.m by P. Moller-Nielson 
%   28.3.03, pm-n. ( see http://www.daimi.au.dk/~pmn/sound/ )

SPECTRUM_SIZE=length(Amp);
peakAmp = ( Amp(3:SPECTRUM_SIZE-1) > Amp(2:SPECTRUM_SIZE-2) ) .* ...
          ( Amp(3:SPECTRUM_SIZE-1) > Amp(4:SPECTRUM_SIZE) ) .* ...
          Amp(3:SPECTRUM_SIZE-1);
peakPos = zeros( MAX_PEAK, 1);

maxAmp = max( peakAmp );
nPeaks = 0;
for p = 1 : MAX_PEAK
  [m, b] = max( peakAmp );
  if m <= ( EPS_PEAK * maxAmp )
    break;
  end;
  peakPos(p) = b+2;
  peakAmp(b) = 0;
  nPeaks = p;
end;

peakPos = sort( peakPos );
peaks = zeros( nPeaks, 3 );

last_b = 1;
for p = 1 : nPeaks
  b = peakPos(MAX_PEAK-nPeaks+p);
  first_b = last_b+1;
  if p == nPeaks
    last_b = SPECTRUM_SIZE;
  else
    next_b = peakPos(MAX_PEAK-nPeaks+p+1);
    [dummy, rel_min] = min( Amp(b:next_b));
    last_b = b+rel_min-1;
  end;
  peaks(p,1) = first_b;
  peaks(p,2) = b;
  peaks(p,3) = last_b;
end;
