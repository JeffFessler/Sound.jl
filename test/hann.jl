# hann.jl

import Sound # hann
import DSP # hanning
using Test: @testset, @test

@testset "hann" begin
   for n in [8, 9]
       @test Sound.hann(n) ≈ DSP.hanning(n+2)[2:end-1]
   end
end
