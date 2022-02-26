# hann.jl

using Sound: hann
using DSP: hanning
using Test: @testset, @test

@testset "hann" begin
   @test hanning(8) ≈ hann(8)
   @test hanning(9) ≈ hann(9)
end
