# record.jl
# elementary audio recording utility function

using PortAudio: PortAudioStream, PortAudioDevice, read, devices
import PortAudio as PA # terminate, initialize, get_default_input_index

export record


"""
    get_default_input_device()
Determine current system-wide default input audio device.
"""
function get_default_input_device()
    PA.terminate()
    PA.initialize()
    isempty(devices()) && throw("No audio devices.")
    return devices()[1 + PA.get_default_input_index()]
end


"""
    data, S = record(time::Real = 5; input_device, args=(1,0), chat::Bool=true)

Record `time` seconds of audio data
using `input_device` (typically defaults to the built-in microphone).

# Input
* `time` : duration; 5 seconds by default

# Option
* `input_device::PortAudioDevice = get_default_input_device()` system default
* `args` : arguments to PortAudioStream;
  `(1,0)` for single-channel input by default
* `chat` : show begin/end message? `true` by default

# Output
* `data` : Vector of length `time * S`
* `S` : `sample_rate` of input stream
"""
function record(
    time::Real = 5 ;
    input_device::PortAudioDevice = get_default_input_device(),
    args = (1,0),
    chat::Bool=true,
    print::Function = (x) -> printstyled(x * "\n"; color=:blue),
)

    input_device.input_bounds.max_channels > 0 ||
        throw("no input channels for $input_device")

    PortAudioStream(input_device, args...) do stream
        S = stream.sample_rate
        N = round(Int, time * S)
        if chat
             print("Begin $time sec recording at rate $S for $N samples from $input_device.")
        end
        buf = read(stream, N)
        data = buf.data
        if size(data) == (size(data,1), 1) # N × 1
            data = vec(data)
        end
        @assert buf.samplerate == S
        if chat
            ext = round.(extrema(data), sigdigits=2)
            print("Recording finished; extrema: $ext.")
        end
        return data, S
    end
end
