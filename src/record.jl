# record.jl
# elementary audio recording utility function

using PortAudio: PortAudioStream, read, devices

export record


"""
    data, S = record(time::Real = 5; args=(1,0), chat::Bool=true)

Record `time` seconds of audio data using the built-in microphone.

# Input
* `time` : duration; 5 seconds by default

# Option
* `args` : arguments to PortAudioStream;
  `(1,0)` for single-channel input by default
* `chat` : show begin/end message? `true` by default

# Output
* `data` : Vector of length `time * S`
* `S` : `sample_rate` of stream 
"""
function record(
    time::Real = 5 ;
    args = (1,0),
    chat::Bool=true,
    print::Function = (x) -> printstyled(x * "\n"; color=:blue),
)

    isempty(devices()) && (@warn("No audio devices."); return nothing)

    PortAudioStream(args...) do stream
        S = stream.sample_rate
        N = round(Int, time * S)
        if chat
             print("Begin $time sec recording at rate $S for $N samples.")
        end
        buf = read(stream, N)
        data = buf.data
        if size(data) == (size(data,1), 1) # N × 1
            data = vec(data)
        end
        @assert buf.samplerate == S
        if chat
            ext = round.(extrema(data), digits=2)
            print("Recording finished; extrema: $ext.")
        end
        return data, S
    end
end
