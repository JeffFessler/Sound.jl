# phase_vocoder.jl

using Sound: phase_vocoder
using Test: @testset, @test, @inferred

@testset "vocoder" begin
    S = 8192
    N = S
    x = cos.(2π*400*(1:N)/S)
    y = @inferred phase_vocoder(x, S)
    @test length(y) == 2N
    y2 = @inferred phase_vocoder([x 2x], S)
    @test y2 ≈ [y 2y]
end
