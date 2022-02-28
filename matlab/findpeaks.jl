# findpeaks.jl
# Compare Matlab and Sound versions of findpeaks.

using Sound: findpeaks
using MATLAB
using Test: @testset, @test

ENV["MATLAB_ROOT"] = "/Applications/freeware/matlab"

@testset "findpeaks" begin
    N = 32
    i = [7, 12, 25]
    M = length(i)
    x = zeros(N)
    x[i] .= [2, 5, 3]
    pj = findpeaks(x)

    mat"pm = findPeaks4($x, 50, 0.005, 0)"
    @mget pm
    pm == Int.(pm)
    @test pj == pm
end
