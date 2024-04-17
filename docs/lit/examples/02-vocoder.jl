#=
# [Phase Vocoder](@id 02-vocoder)

This page illustrates the
[phase vocoder](https://en.wikipedia.org/wiki/Phase_vocoder)
feature of the Julia package
[`Sound`](https://github.com/JeffFessler/Sound.jl).
=#

#srcURL


# ### Setup

# Packages needed here.

using Sound: phase_vocoder, soundsc, hann
using DSP: spectrogram
using MIRTjim: jim, prompt
using Plots: plot
using InteractiveUtils: versioninfo


# The following line is helpful when running this file as a script;
# this way it will prompt user to hit a key after each figure is displayed.

isinteractive() ? jim(:prompt, true) : prompt(:draw);


#=
## Overview

Here we illustrate applying the phase vocoder
to stretch time (by the default factor of 2).
=#

S = 8192*2^2
x1 = cos.(2π*400*(1:2S)/S) .* hann(2S)
x2 = cos.(2π*300*(1:S)/S) .* hann(S)
x3 = cos.(2π*500*(1:S)/S).^3 .* hann(S) # nonlinearity for harmonics
x = [x1; x2; x3] # 4-note song
y = phase_vocoder(x, S)
length(x), length(y)

# spectrograms
sx = spectrogram(x / maximum(abs, x); fs=S)
sy = spectrogram(y / maximum(abs, y); fs=S)
dB = x -> max(log10.(x), -10)
fun = (s) -> jim(s.time, s.freq, dB.(s.power)', aspect_ratio = :auto,
    color = :viridis, clim = (-10,0), yflip = false,
    yaxis = ("freq", (0,1800), 0:300:1800),
    xlabel="time",
    prompt = false,
)
p0 = jim(fun(sx), fun(sy))


# listen to before/after:
isinteractive() && soundsc([x; y], S)

#=
The following time plots
show the original signal
and the time-stretched version.
Clearly something is awry.
=#

p1 = plot((1:length(x))/S, x, label="x(t) original",
 xaxis = ("t [s]", (0, 4), 0:4),
 yaxis = ("", (-1, 1), -1:1),
 size = (600, 300),
)
ymax = ceil(maximum(abs, y)) # why not "1" ?
p2 = plot((1:length(y))/S, y, label="y(t) processed",
 xaxis = ("t [s]", (0, 8), 0:2:8),
 yaxis = ("", (-1, 1).*ymax, (-1:1)*ymax),
 size = (600, 300),
)
p12 = plot(p1, p2; layout=(2,1))


include("../../../inc/reproduce.jl")
