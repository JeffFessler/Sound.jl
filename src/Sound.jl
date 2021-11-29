"""
    Sound
Module that exports the `sound` method.
"""
module Sound

using PortAudio: PortAudioStream, write
using Requires: @require

export sound, soundsc


"""
    sound(x::AbstractVector, S::Real = 8192)
Play monophonic audio signal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
Default sampling rate is `S = 8192` samples per second.
"""
sound(x::AbstractVector, S::Real = 8192) = sound(reshape(x, :, 1), S)


"""
    sound(x::AbstractMatrix, S::Real = 8192)
Play stereo audio signal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
Default sampling rate is `S = 8192` samples per second.
"""
function sound(x::AbstractMatrix, S::Real = 8192)
    if size(x,1) == 1 # row "vector"
        x = vec(x) # convenience
    end
    size(x,2) ≤ 2 || throw("size(x,2) = $(size(x,2)) is too many channels")
    PortAudioStream(0, 2; samplerate=Float64(S)) do stream
        write(stream, x)
    end
end


"""
    soundsc(x, S::Real = 8192)
Play mono or stereo audio signal `x`
at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package,
after scaling `x` to have values in `(-1,1)`.
Default sampling rate is `S = 8192` samples per second.
"""
soundsc(x::AbstractArray, S::Real = 8192) =
    sound(x * prevfloat(1.0) / maximum(abs, x), S)


# support SampledSignals iff user has loaded that package
function __init__()
	@require SampledSignals = "bd7594eb-a658-542f-9e75-4c4d8908c167" include("sample-buf.jl")
end

end # module
