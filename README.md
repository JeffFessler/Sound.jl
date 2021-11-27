# Sound

https://github.com/JeffFessler/Sound.jl

[![action status][action-img]][action-url]
[![pkgeval status][pkgeval-img]][pkgeval-url]
[![codecov][codecov-img]][codecov-url]
[![license][license-img]][license-url]
[![docs-stable][docs-stable-img]][docs-stable-url]
[![docs-dev][docs-dev-img]][docs-dev-url]
[![code-style][code-blue-img]][code-blue-url]

This Julia repo exports the function `sound`
that plays an audio signal through a computer's speakers.
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

See the
[documentation](https://jefffessler.github.io/Sound.jl/stable).


Matlab also has a
[`soundsc`](https://www.mathworks.com/help/matlab/ref/soundsc.html)
command
that scales the audio;
such scaling is already built into `sound` here,
so `soundsc` is unnecessary.

### Compatibility

Tested with Julia ≥ 1.6.


### Related packages

* https://github.com/dancasimiro/WAV.jl
  has a similar `wavplay` function
* https://github.com/JuliaAudio/PortAudio.jl
  The `sound` function is just a wrapper around functions in this package.


<!-- URLs -->
[action-img]: https://github.com/JeffFessler/Sound.jl/workflows/CI/badge.svg
[action-url]: https://github.com/JeffFessler/Sound.jl/actions
[build-img]: https://github.com/JeffFessler/Sound.jl/workflows/CI/badge.svg?branch=main
[build-url]: https://github.com/JeffFessler/Sound.jl/actions?query=workflow%3ACI+branch%3Amain
[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/S/Sound.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/S/Sound.html
[code-blue-img]: https://img.shields.io/badge/code%20style-blue-4495d1.svg
[code-blue-url]: https://github.com/invenia/BlueStyle
[codecov-img]: https://codecov.io/github/JeffFessler/Sound.jl/coverage.svg?branch=main
[codecov-url]: https://codecov.io/github/JeffFessler/Sound.jl?branch=main
[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JeffFessler.github.io/Sound.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://JeffFessler.github.io/Sound.jl/dev
[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat
[license-url]: LICENSE
