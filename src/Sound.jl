"""
    Sound
Module that exports the `sound` method.
"""
module Sound

using PortAudio
using SampledSignals

export sound


"""
    sound(x::AbstractVector, S::Real)
Play monophonic audiosignal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
"""
function sound(x::AbstractVector, S::Real)
    PortAudioStream(0, 2; samplerate=Float64(S)) do stream
        write(stream, x)
    end
end


"""
    sound(x::AbstractMatrix, S::Real)
Play stereo audiosignal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
"""
function sound(x::AbstractMatrix, S::Real)
    size(x,2) == 2 || throw("size(x,2) = $(size(x,2)) is too many channels")
    PortAudioStream(0, 2; samplerate=Float64(S)) do stream
        write(stream, x)
    end
end


"""
    sound(x)
Play mono or stereo audio signal `x`
at default sampling rate 8192 samples per second
through default audio output device using the `PortAudio` package.
"""
sound(x::AbstractArray) = sound(x, 8192)


end # module
