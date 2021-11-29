"""
    Sound
Module that exports the `sound` method.
"""
module Sound

using PortAudio
using SampledSignals: write, SampleBuf

export sound, soundsc


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


"""
    soundsc(x, S::Real)
Play mono or stereo audio signal `x`
at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package,
after scaling `x` to have values in `(-1,1)`.
"""
soundsc(x::AbstractArray, S::Real) =
    sound(x * prevfloat(1.0) / maximum(abs, x), S)


"""
    soundsc(x)
Play mono or stereo audio signal `x`
at default sampling rate 8192 samples per second
through default audio output device using the `PortAudio` package,
after scaling `x` to have values in `(-1,1)`.
"""
soundsc(x::AbstractArray) = soundsc(x, 8192)


"""
    sound(sb:SampleBuf)
Play audio signal `sb` of type `SampleBuf`
through default audio output device using the `PortAudio` package.
"""
sound(sb::SampleBuf) = sound(sb.data, sb.samplerate)


"""
    soundsc(sb:SampleBuf)
Play audio signal `sb` of type `SampleBuf`
through default audio output device using the `PortAudio` package,
after scaling the data to have values in `(-1,1)`.
"""
soundsc(sb::SampleBuf) = soundsc(sb.data, sb.samplerate)


end # module
