# runtests.jl

using Test: @test, @testset, @test_throws, detect_ambiguities
using Sound # sound, soundsc
using SampledSignals: SampleBuf

@testset "Sound" begin

    S = 8192 # sampling rate in Hz
    x = 0.8 * cos.(2pi*(1:800)*440/S)
    y = 0.7 * sin.(2pi*(1:800)*660/S)
    sound(x, S) # specify sampling rate
    sound(y) # use default sampling rate of 8192 Hz
    sound([x y]) # stereo
    soundsc(0.1*x) # scale

    sb = SampleBuf(x, S)
    sound(sb)
    soundsc(sb)

    @test_throws String sound(ones(5,3))

    @test isempty(detect_ambiguities(Sound))
end
