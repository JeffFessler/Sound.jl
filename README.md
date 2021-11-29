# Sound

https://github.com/JeffFessler/Sound.jl

[![action status][action-img]][action-url]
[![pkgeval status][pkgeval-img]][pkgeval-url]
[![codecov][codecov-img]][codecov-url]
[![license][license-img]][license-url]
[![docs-stable][docs-stable-img]][docs-stable-url]
[![docs-dev][docs-dev-img]][docs-dev-url]
[![code-style][code-blue-img]][code-blue-url]

This Julia repo exports the functions
`sound`
and
`soundsc`
that play an audio signal through a computer's speakers.
Their use is designed to be similar to that of Matlab commands
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
x = 0.7*cos.(2pi*(1:S÷2)*440/S)
y = 0.8*sin.(2pi*(1:S÷2)*660/S)
sound(x, S) # specify sampling rate
sound(y) # use default sampling rate of 8192 Hz
sound([x y]) # stereo
soundsc([x y], S) # scale to maximum volume
```

See the
[documentation](https://jefffessler.github.io/Sound.jl/stable).


As a nod towards the Julia way of doing things,
both `sound` and `soundsc`
also support the `SampleBuf` type
in the
[SampledSignals.jl](https://github.com/JuliaAudio/SampledSignals.jl)
package.
That type carries the sampling rate
along with the signal data,
which is attractive
compared to having two separate variables.

```julia
using Sound
using SampledSignals: SampleBuf
S = 8192 # sampling rate in Hz
x = 0.7*cos.(2pi*(1:S÷2)*440/S)
y = 0.8*sin.(2pi*(1:S÷2)*660/S)
sb = SampleBuf([x y], S) # stereo data
sound(sb)
soundsc(sb) # scale to maximum volume
```


### Compatibility

Tested with Julia ≥ 1.6.


### Related packages

* https://github.com/dancasimiro/WAV.jl
  has a similar `wavplay` function
* https://github.com/JuliaAudio/PortAudio.jl  
  Currently, the `sound` function here is just a wrapper
  around functions in this package.
  However that could change in the future
  to support other audio back-ends,
  much like how
  [`Plots.jl`](https://github.com/JuliaPlots/Plots.jl)
  provides a common interface to various plotting back-ends.


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
