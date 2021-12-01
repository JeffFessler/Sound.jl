"""
    Sound

Module that exports wrappers around audio methods in `PortAudio`.
* `sound` and `soundsc` : methods for audio playback.
* `record` : method for audio recording.
"""
module Sound

include("soundsc.jl")
include("record.jl")

# support SampledSignals iff user has loaded that package
function __init__()
    @require SampledSignals = "bd7594eb-a658-542f-9e75-4c4d8908c167" include("sample-buf.jl")
end

end # module
