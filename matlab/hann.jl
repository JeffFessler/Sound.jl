# hann.jl
# Compare Matlab and Sound versions
# Note that Matlab has "hann" and "hanning" and they differ!

using Sound: hann
using MATLAB
using Test: @testset, @test

ENV["MATLAB_ROOT"] = "/Applications/freeware/matlab"

@testset "hann" begin
    for n in [8, 9] # test odd and even
        eval_string("h1 = hanning($n)")
        eval_string("h2 = hann($n+2)")
        @mget h1
        @mget h2
        @test [0; h1; 0] ≈ h2
        @test h1 ≈ hann(n)
    end
end
