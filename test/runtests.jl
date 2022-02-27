# runtests.jl

using Test: @test, @testset, @test_throws, @inferred, detect_ambiguities
using Sound # sound, soundsc, record, pick_output
using SampledSignals: SampleBuf
using PortAudio: devices, PortAudioDevice

# include("aqua.jl") # fails in Interval, Unitful ...

@show devices()

if isempty(devices())
    @warn "No devices so no tests on this OS."
else

@testset "output" begin
    dev = @inferred Sound.get_default_output_device()
    @test dev isa PortAudioDevice

    index = findfirst(==(dev), devices())
    io_out = IOBuffer()
    io_in = IOBuffer("$index")
    tmp = @inferred Sound.pick_output( ; io_in, io_out)
    @test tmp === dev

    io_in = IOBuffer("\n")
    tmp = @inferred Sound.pick_output( ; io_in, io_out)
    @test tmp === dev

    io_in = IOBuffer("$index")
    sound(:pick, randn(500), 1000; io_in, io_out)
    sound(index, randn(500), 1000)
    @test_throws String sound(0, randn(500), 1000)
end


@testset "Sound" begin
    S = 8192 # sampling rate in Hz
    x = 0.8 * cos.(2π*(1:800)*440/S)
    y = 0.7 * sin.(2π*(1:800)*660/S)
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
    dev = @inferred Sound.get_default_input_device()
    @test dev isa PortAudioDevice

    data, S = record(0.001)
    @test S isa Real
    @test data isa Vector
end

end # !isempty(devices())


include("hann.jl")
include("findpeaks.jl")
