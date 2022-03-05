Phase vocoder code in Matlab from
https://www.ee.columbia.edu/~dpwe/resources/matlab/pvoc

The .m files were downloaded circa 2014
and I made two small modifications
that can be seen by comparing stft.m with stft-original.m.


Below is the index.html contents from that page, downloaded 2022-03-05.
I am including it here because Dan Ellis is now at Google
rather than Columbia (according to his web page)
so I am unsure how long his Columbia web page will remain active.



Dan Ellis : Resources : Matlab :

### A Phase Vocoder in Matlab

### Introduction

The Phase Vocoder [FlanG66, Dols86, LaroD99] is an algorithm for timescale
modification of audio.  One way of understanding it is to think of it as
stretching or compressing the time-base of a spectrogram to change the
temporal characteristics of a sound while retaining its short-time spectral
characteristics; if the spectrogram is narrowband (analysis window longer than
a pitch cycle, so the individual harmonics are resolved), then preserving the
spectral characteristics implies preserving the pitch, and avoiding the
'slowing down the tape' pitch drop.  The only complication to the algorithm is
that the phases associated with each bin in the modified spectrogram image
have to be 'fixed up' to maintain the dphase/dtime of the original, thereby
ensuring the correct alignment of successive windows in the overlap-add
reconstruction.

I first wrote a phase vocoder in 1990 which eventually became the `pvoc` unit
generator in
[Csound](http://www.csounds.com/manual/html/pvoc.html).
This implementation is a lot smaller and took much less time to debug!
It first calculates the short-time Fourier transform of the signal using `stft`;
`pvsample` then builds a modified spectrogram array
by sampling the original array at a sequence of fractional time values,
interpolating the magnitudes and fixing-up the phases as it goes along.
The resulting time-frequency array can be inverted back into a sound
with `istft`.
The `pvoc` script is a wrapper to perform all three of these steps
for a fixed time-scaling factor
(larger than one for speeding up; smaller than one to slow down).
But the underlying `pvsample` routine would also support
arbitrary timebase variation
(freezing, reversal, modulation)
if one wished to write a suitable interface to specify the time path.

### Code

These were developed on Matlab 5.0, but should work on any version.

* `pvoc.m` - the top-level routine
* `stft.m` - calculate the STFT time-frequency representation
* `pvsample.m` - interpolate/reconstruct the new STFT on the modified timebase
* `istft.m` - overlap-add the modified STFT back into a waveform

Here's an example of how to use `pvoc`
to slow down a soundfile of voice (sampled at 16 kHz) to 3/4 speed:

```matlab
» [d,sr] = wavread('sf1_cln.wav');
» sr
sr = 16000
» % 1024 samples is about 60 ms at 16kHz, a good window
» y=pvoc(d, .75, 1024);
» % Compare original and resynthesis
» sound(d, 16000)
» sound(y, 16000)
```

Here's how to use phase vocoder time-scale modification
followed by resampling to effect a pitch shift.
In this case, we shift the pitch up by a major third
(by extending duration with the phase vocoder,
then resampling to the original length),
then add it back to the initial sound to give harmonization:

```matlab
» [d,sr]=wavread('clar.wav');
» e = pvoc(d, 0.8);
» f = resample(e,4,5); % NB: 0.8 = 4/5
» soundsc(d(1:length(f))+f, sr)
```

(Thanks to Martín Rocamora for fixing the bug here!)

FAQs
Q. In pvsample.m, I see you first subtract `dphi` from the phase difference,
then add it back in before cumulating the phase. Why bother?

A. `dphi` is set up as:

`dphi(2:(1 + N/2)) = (2*pi*hop)./(N./(1:(N/2)));`

It's the phase advance you'd expect to see from a sinusoid
at the center frequency of bin n of an N point FFT
if you shifted the window by hop points.
We only worry about the lowest N/2+1 bins,
since the remainder are conjugate-symmetric.

`N./(1:(N/2))` is the cycle length of the sinusoids
at the center of bins `1:N/2` of the FFT (counting from 0) --
i.e.,
FFT bin 1 corresponds to a sinusoid that completes 1 cycle in N samples
(period N/1),
and the highest bin (bin N/2)
corresponds to a sinusoid that completes 1 cycle every 2 samples,
i.e., period N/(N/2).
So `hop/(N./(1:N/2))` is the proportion of a cycle represented by hop samples,
and `2*pi*...` is that cycle proportion in radians.

We're interested in estimating the frequency of a sinusoid
that would give the phase difference we observe,
but the phase difference is modulo 2pi
(i.e., we only know it to within +/- r.2pi),
so we have to guess a range.
That's the function of `dphi`:
our 'starting point' is to assume the sinusoid exciting bin n
is exactly at the center frequency of that bin,
in which case it would give an expected phase difference of `dphi(n)`.
So the final value of `dp` in each column
is actually the deviation from the expected phase advance in each bin;
we can convert these into our best guess of the frequency in each bin
as `freq(n) = 2*pi*n/N + dp(n)/hop`
(in radians per sample).

When we come to reconstruct the output spectrogram,
for each column we cumulate a phase advance consistent
with the current sampling point in the original STFT -
which is just the original phase difference,
assuming the output and input hop sizes match.
But if the output `hopsize` was different,
we'd need to know the actual effective frequency of the bin center,
so we could scale it by a different `ohop`
before collapsing down to `-pi:pi`.
That's when separating into `dphi` and `dp` would be important.

But, you're correct, in the current code it does nothing!

References
* [FlanG66]
J. L. Flanagan, R. M. Golden, "Phase Vocoder," Bell System Technical Journal, November 1966, 1493-1509.
http://www.ee.columbia.edu/~dpwe/e6820/papers/FlanG66.pdf
* [Port76]
M. R. Portnoff, "Implementation of the Digital Phase Vocoder Using the Fast Fourier Transform," IEEE Trans. Acous., Speech, Sig. Proc., 24(3), June 1976, 243-248. http://www.ee.columbia.edu/~dpwe/papers/Portnoff76-pvoc.pdf
* [Dols86]
Mark Dolson, "The phase vocoder: A tutorial," Computer Music Journal, vol. 10, no. 4, pp. 14 -- 27, 1986.
http://www.panix.com/~jens/pvoc-dolson.par
* [LaroD99]
Jean Laroche and Mark Dolson "New Phase Vocoder Technique for Pitch-Shifting, Harmonizing and Other Exotic Effects". IEEE Workshop on Applications of Signal Processing to Audio and Acoustics. Mohonk, New Paltz, NY. 1999.
http://www.ee.columbia.edu/~dpwe/papers/LaroD99-pvoc.pdf

There are also recommended tutorials at Stephan Bernsee's DSP dimension
and by Bill Sethares at Wisconsin.

Referencing this work

I do not have any publication describing this code,
since it is basically a straightforward implementation
of the Flanagan & Golden / Dolson phase vocoder.
However, if you use this code and would like to acknowledge it with a reference,
you could consider something like this:

@misc{Ellis02-pvoc
  author = {D. P. W. Ellis},
  year = {2002},
  title = {A Phase Vocoder in {M}atlab},
  note = {Web resource},
  url = {http://www.ee.columbia.edu/~dpwe/resources/matlab/pvoc/},
}

History

2003-03-06 Added pitch shifting/harmonization example

2002-02-13 Revised version uses stft/istft for perfect reconstruction when r = 1. More stuff on page.

2000-12-11 First version of this page, after demo'ing in E4810.

Last updated: $Date: 2010/10/26 18:55:10 $

Dan Ellis <dpwe@ee.columbia.edu>
