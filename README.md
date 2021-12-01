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

`Sound` is a registered package,
so installation is easy:

```julia
import Pkg; Pkg.add("Sound")
```


## Example

```julia
using Sound
S = 8192 # sampling rate in Hz
x = 0.7*cos.(2pi*(1:S÷2)*440/S)
y = 0.8*sin.(2pi*(1:S÷2)*660/S)
sound(x, S) # monophonic
sound([x y], S) # stereo
soundsc([x y], S) # scale to unit amplitude
```

See the
[documentation](https://jefffessler.github.io/Sound.jl/stable).


Matlab's
[`audioplayer`](https://www.mathworks.com/help/matlab/ref/audioplayer.html)
has the same arguments as `sound`,
so you can type
`audioplayer = sound`
and then call
`audioplayer(x, S)`
if desired,
albeit without any of other features of `audioplayer`.

As a nod towards the Julia way of doing things,
both `sound` and `soundsc`
also support the `SampleBuf` type
in the
[SampledSignals.jl](https://github.com/JuliaAudio/SampledSignals.jl)
package,
via
[Requires.jl](https://github.com/JuliaPackaging/Requires.jl).
That type carries the sampling rate
along with the signal data,
which is attractive
compared to having two separate variables.

```julia
using Sound
using SampledSignals: SampleBuf # you may need to add this package
S = 8192 # sampling rate in Hz
x = 0.7*cos.(2pi*(1:S÷2)*440/S)
y = 0.8*sin.(2pi*(1:S÷2)*660/S)
sb = SampleBuf([x y], S) # stereo data
sound(sb)
soundsc(sb) # scale to maximum volume
```


## Audio recording

There is also a simple `record` method here
for recording from the default microphone.
It returns a Vector of the sample data
and the audio system default sampling rate.

```julia
using Sound: record
data, S = record(4) # record 4 seconds of audio data
```


## Compatibility

Tested with Julia ≥ 1.6.


## Caveats

Because Julia code is compiled,
the first time you call an audio function
the sound can be jittery.
Subsequent calls
(with the same argument types)
usually work as expected.

On MacOS, if you run Julia from an xterm in XQuartz,
then (at least as of XQuartz v2.8.1)
no audio will be recorded
because XQuartz does not ask for permission
to access the microphone.
Running Julia within the Terminal app is required
because Terminal will properly request microphone permissions.


## Related packages

* https://github.com/haberdashPI/SignalBase.jl
  supports a `framerate` method that serves as the default sampling rate here.
* https://github.com/haberdashPI/SignalOperators.jl
  has useful audio processing operations.
* https://github.com/dancasimiro/WAV.jl
  has a similar `wavplay` function
* https://github.com/JuliaAudio
  has a collection of audio packages.
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
