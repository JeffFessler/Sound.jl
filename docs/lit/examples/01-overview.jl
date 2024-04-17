#=
# [Sound overview](@id 01-overview)

This page illustrates the Julia package
[`Sound`](https://github.com/JeffFessler/Sound.jl).
=#

#srcURL

# ### Setup

# Packages needed here.

using Sound
using SampledSignals: SampleBuf
using InteractiveUtils: versioninfo


#=
### Overview

The primary purpose of this package, at least initially,
was to provide a simple way to hear audio signals in Julia.
=#

S = 8192 # sampling rate in Hz
x = 0.7*cos.(2π*(1:S÷2)*440/S)
y = 0.8*sin.(2π*(1:S÷2)*660/S)
isinteractive() && sound(x, S) # monophonic

# stereo:
isinteractive() && sound([x y], S)

# scale to unit amplitude:
isinteractive() && soundsc([x y], S)


# Using `SampleBuf` may provide some convenience.

S = 8192 # sampling rate in Hz
x = 0.7 * cos.(2π*(1:S÷2)*440/S)
y = 0.8 * sin.(2π*(1:S÷2)*660/S)
sb = SampleBuf([x y], S) # stereo data
isinteractive() && sound(sb)


include("../../../inc/reproduce.jl")
