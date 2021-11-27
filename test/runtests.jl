# runtests.jl

using Test: @test, @testset, @test_throws, detect_ambiguities
using Sound # sound, soundsc

@testset "Sound" begin

    S = 8192 # sampling rate in Hz
    x = cos.(2pi*(1:800)*440/S)
    y = sin.(2pi*(1:800)*660/S)
    sound(x, S) # specify sampling rate
    sound(y) # use default sampling rate of 8192 Hz
    sound([x y]) # stereo
    soundsc(0.1*x) # scale

    @test_throws String sound(ones(5,3))

    @test isempty(detect_ambiguities(Sound))
end
