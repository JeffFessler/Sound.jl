#=
phase_vocoder.jl
=#

using Sound: phase_vocoder
using Test: @testset, @test

@testset "vocoder" begin
    S = 8192
    N = S
    x = cos.(2π*400*(1:N)/S)
    y = phase_vocoder(x, S)
    @test length(y) == 2N
end
