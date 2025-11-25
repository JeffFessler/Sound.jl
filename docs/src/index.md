```@meta
CurrentModule = Sound
```

# Sound.jl Documentation

## Contents

```@contents
```

## Overview

The Julia module
[`Sound.jl`](https://github.com/JeffFessler/Sound.jl)
exports a function `sound`
for playing an audio signal
through a computer audio output.

Its usage is designed to be similar to that of
[Matlab's `sound` command](https://www.mathworks.com/help/matlab/ref/sound.html)
to facilitate migration.

## Getting started

```julia
using Pkg
Pkg.add("Sound")
```

## Example

```julia
using Sound
S = 8192 # sampling rate in Hz
x = cos.(2pi*(1:S÷2)*440/S)
y = sin.(2pi*(1:S÷2)*660/S)
sound(x, S) # specify sampling rate
sound(y) # use default sampling rate of 8192 Hz
sound([x y]) # stereo
```

Matlab also has a
[`soundsc`](https://www.mathworks.com/help/matlab/ref/soundsc.html)
command
that scales the audio;
such scaling is already built into `sound` here,
so `soundsc` is unnecessary.
