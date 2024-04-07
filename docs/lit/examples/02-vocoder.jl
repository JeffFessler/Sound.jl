#=
# [Phase Vocoder](@id 02-vocoder)

This page illustrates the phase vocoder feature of the Julia package
[`Sound`](https://github.com/JeffFessler/Sound.jl).

This page was generated from a single Julia file:
[02-vocoder.jl](@__REPO_ROOT_URL__/02-vocoder.jl).
=#

#srcURL


# ### Setup

# Packages needed here.

using Sound: phase_vocoder, soundsc, hann
using DSP: spectrogram
using MIRTjim: jim, prompt
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
x2 = cos.(2π*300*(1:S)/S).^3 .* hann(S) # nonlinearity for harmonics
x = [x1; x2] # 2-note song
y = phase_vocoder(x, S)
length(x), length(y)

# spectrograms
sx = spectrogram(x / maximum(abs, x); fs=S)
sy = spectrogram(y / maximum(abs, y); fs=S)
dB = x -> max(log10.(x), -10)
fun = (s) -> jim(s.time, s.freq, dB.(s.power)', aspect_ratio=:auto,
    ylims = (0,1800), color=:viridis, clim = (-10,0),
    yticks = 0:300:1800, yflip=false,
    xlabel="time", ylabel="freq",
    prompt = false,
)
jim(fun(sx), fun(sy))


# listen to before/after:
soundsc([x; y], S)


# ### Reproducibility

# This page was generated with the following version of Julia:

io = IOBuffer(); versioninfo(io); split(String(take!(io)), '\n')


# And with the following package versions

import Pkg; Pkg.status()
