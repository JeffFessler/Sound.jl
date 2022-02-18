# soundsc.jl

using PortAudio: PortAudioStream, PortAudioDevice, write, devices
import PortAudio as PA # terminate, initialize, get_default_output_index
using Requires: @require
import SignalBase: framerate

export sound, soundsc


# fallback
framerate(x::Any) = error("The signal you are trying to play as a sound ",
 "does not have a known sampling rate. ",
 "Consider wrapping in a `SampleBuf` or defining `framerate(x::MyType)`.")


"""
    pick_output( ; io_in::IO = stdin, io_out::IO = stdout)
Show available audio devices and
prompt user to select output device.
"""
function pick_output( ; io_in::IO = stdin, io_out::IO = stdout)
    devs = devices()
    outable = map(x -> x.output_bounds.max_channels > 0, devs)
    any(outable) || throw("no output devices?")
    devnum = findfirst(outable)
    for (i,dev) in enumerate(devs)
       println(io_out, outable[i] ? i : "?", " ", dev)
    end
    print(io_out, "pick output device [$devnum]: ")
    char = read(io_in, Char)
    if char == '\n'
        return devs[devnum]
    end
    index = char - '0'
    (1 ≤ index ≤ length(devs) && outable[index]) || throw("bad index $index")
    return devs[index]
end


"""
    sound(x::AbstractVector, S::Real = framerate(x), args...; kwargs...)
Play monophonic audio signal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
Caller must specify `S` unless a `framerate` method is defined for `x`.
"""
sound(x::AbstractVector, S::Real = framerate(x), args...; kwargs...) =
    sound(reshape(x, :, 1), S, args...; kwargs...)


"""
    sound(:pick, x, S::Real = framerate(x); kwargs...)
Prompt user to pick output device, then play sound in `x`.
"""
sound(::Symbol,
    x::AbstractArray,
    S::Real = framerate(x) ;
    io_in::IO = stdin,
    io_out::IO = stdout,
    kwargs...
) = sound(x, S, pick_output( ; io_in, io_out); kwargs...)


"""
    get_default_output_device()
Determine current system-wide default output audio device.
"""
function get_default_output_device()
    PA.terminate()
    PA.initialize()
    isempty(devices()) && throw("No audio devices.")
    return devices()[1 + PA.get_default_output_index()]
end


"""
    sound(output_device_index::Int, x, S::Real = framerate(x); kwargs...)
Play sound in `x` using `devices()[output_device_index]`.
"""
function sound(
    index::Int,
    x::AbstractArray,
    S::Real = framerate(x) ;
    kwargs...
)
    devs = devices()
    (1 ≤ index ≤ length(devs)) || throw("bad index $index")
    dev = devs[index]
    dev.output_bounds.max_channels > 0 || throw("no output channels")
    sound(x, S, dev; kwargs...)
end


"""
    sound(x::AbstractMatrix, S::Real = framerate(x) [, output_device])
Play stereo audio signal `x` at sampling rate `S` samples per second
through default audio output device using the `PortAudio` package.
Caller must specify `S` unless a `framerate` method is defined for `x`.
"""
function sound(
    x::AbstractMatrix,
    S::Real = framerate(x),
    output_device::PortAudioDevice = get_default_output_device(),
)
    if size(x,1) == 1 # row "vector"
        x = vec(x) # convenience
    end
    size(x,2) ≤ 2 || throw("size(x,2) = $(size(x,2)) is too many channels")

    output_device.output_bounds.max_channels > 0 ||
        throw("no output channels for $output_device")

    PortAudioStream(output_device, 0, 2; samplerate=Float64(S)) do stream
        write(stream, x)
    end
end


"""
    soundsc(x, S::Real = framerate(x), args...; kwargs...)
Call `sound` after scaling `x` to have values in `(-1,1)`.
"""
soundsc(x::AbstractArray, S::Real = framerate(x), args...; kwargs...) =
    sound(x * prevfloat(1.0) / maximum(abs, x), S, args...; kwargs...)
