"""
    Sound
Module that exports the `sound` method.
"""
module Sound

using PortAudio: PortAudioStream, write
using Requires: @require

export sound, soundsc


framerate(x::Any) = error("The signal you are trying to play as a sound ",
 "does not have a known sampling rate. ",
 "Consider wrapping in a `SampleBuf` or defining `framerate(x::MyType)`")


"""
    sound(x::AbstractVector, S::Real = framerate(x))
Play monophonic audio signal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
Caller must specify `S` unless a `framerate` method is defined for `x`.
"""
sound(x::AbstractVector, S::Real = framerate(x)) = sound(reshape(x, :, 1), S)


"""
    sound(x::AbstractMatrix, S::Real = framerate(x))
Play stereo audio signal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
Caller must specify `S` unless a `framerate` method is defined for `x`.
"""
function sound(x::AbstractMatrix, S::Real = framerate(x))
    if size(x,1) == 1 # row "vector"
        x = vec(x) # convenience
    end
    size(x,2) ≤ 2 || throw("size(x,2) = $(size(x,2)) is too many channels")
    PortAudioStream(0, 2; samplerate=Float64(S)) do stream
        write(stream, x)
    end
end


"""
    soundsc(x, S::Real = framerate(x))
Call `sound` after scaling `x` to have values in `(-1,1)`.
"""
soundsc(x::AbstractArray, S::Real = framerate(x)) =
    sound(x * prevfloat(1.0) / maximum(abs, x), S)


# support SampledSignals iff user has loaded that package
function __init__()
	@require SampledSignals = "bd7594eb-a658-542f-9e75-4c4d8908c167" include("sample-buf.jl")
end

end # module
