#=
findpeaks.jl
=#

using Sound: findpeaks
using Test: @testset, @test

@testset "findpeaks" begin
    N = 32
    i = [7, 12, 25]
    M = length(i)
    x = zeros(N)
    x[i] .= [2, 5, 3]
    p = findpeaks(x)
    @test p[:,1] == [2; 2 .+ i[1:(M-1)]]
    @test p[:,2] == i
    @test p[:,3] == [1 .+ i[1:(M-1)]; N]
end
