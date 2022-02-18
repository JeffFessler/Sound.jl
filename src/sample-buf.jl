# sample-buf.jl

using .SampledSignals: write, SampleBuf

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
