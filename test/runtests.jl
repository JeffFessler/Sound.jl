# runtests.jl

using Test: @test, @testset, @test_throws, detect_ambiguities
using Sound # sound, soundsc, record
using SampledSignals: SampleBuf

@testset "Sound" begin

    S = 8192 # sampling rate in Hz
    x = 0.8 * cos.(2pi*(1:800)*440/S)
    y = 0.7 * sin.(2pi*(1:800)*660/S)
    sound(x, S) # specify sampling rate
    @test_throws ErrorException sound(y) # unknown sampling rate
    sound([x y], S) # stereo
    soundsc(0.1 * reshape(x,1,:), S) # scale and row vector

    sb = SampleBuf(x, S)
    sound(sb)
    soundsc(sb)

    @test_throws String sound(ones(5,3), S) # array size

    @test isempty(detect_ambiguities(Sound))
end


@testset "record" begin
	tmp, S = record(0.001)
	@test S isa Real
	@test tmp isa Vector
end
