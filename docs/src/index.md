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
x = 0.6 * cos.(2π*(1:S÷2)*440/S)
y = 0.7 * sin.(2π*(1:S÷2)*660/S)
sound(x, S) # monophonic
sound([x y], S) # stereo
soundsc([x y], S) # scale to maximum volume
```


## PortAudio on Linux


This package is layered on top of
[PortAudio](https://github.com/JuliaAudio/PortAudio.jl).
Some users have reported challenges on Linux OS
in overcoming security access to the microphone,
with errors like
`PortAudioException: Device unavailable`.
Here is an approach that worked
[for one user in 2024](https://piazza.com/class/lq11s0j6l3s3qo/post/104),
using Julia 1.10.2.

- Install the `alsa dev tools` package.
  For a debian-based distro, use
  `sudo apt install libasound-dev`,
  which automatically changed the package to `libasound2-dev` instead.
- Download
  [`PortAudio`](https://files.portaudio.com/download.html)
  directly (not the julia package)
  and extract the archive.
  I put the directory in my home folder but I’m not sure how much it matters.
- Follow the PortAudio
  [linux build instructions](https://portaudio.com/docs/v19-doxydocs/compile_linux.html)
  up through `sudo make install`
- Run `sudo ldconfig` to allow access to other programs (such as `julia`).
- Caveat: This works inconsistently and requires frequent restarts of julia.
