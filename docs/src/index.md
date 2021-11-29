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
exports the functions
`sound`
and
`soundsc`
for playing an audio signal
through a computer audio output.

Their use is designed to be similar to Matlab commands
[`sound`](https://www.mathworks.com/help/matlab/ref/sound.html)
and
[`soundsc`](https://www.mathworks.com/help/matlab/ref/soundsc.html)
to facilitate code migration.


## Getting started

```julia
using Pkg
Pkg.add("Sound")
```


## Example

```julia
using Sound
S = 8192 # sampling rate in Hz
x = 0.6 * cos.(2pi*(1:S÷2)*440/S)
y = 0.7 * sin.(2pi*(1:S÷2)*660/S)
sound(x, S) # monophonic
sound([x y], S) # stereo
soundsc([x y], S) # scale to maximum volume
```
