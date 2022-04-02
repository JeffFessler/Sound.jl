# vocoder.jl
# Compare Matlab and Sound versions of phase vocoder.

using Sound: phase_vocoder, hann, soundsc
using MATLAB
using Test: @testset, @test

ENV["MATLAB_ROOT"] = "/Applications/freeware/matlab"

@testset "vocoder" begin
end
    S = 44100
    N = S ÷ 5
    hopin = 121.
#   hopout = hopin * 2
    hopout = hopin * 1.5 # todo: large differences
# for hopin in (100., 121.), hopout in hopin .* (1, 1.5, 0.5)
@show hopin, hopout
    f = 540
    x = sin.(2π*f*(1:N)/S)
    yj = phase_vocoder(x, S; hopin, hopout)

    @show "start matlab"
    Nd = Float64(N)
    x2 = reshape(x, :, 1)
    mat"ym = pv($x2, $Nd, $hopin, $hopout)"
    @mget ym
    ym = Float32.(vec(ym))

    @show extrema(yj)
    @show extrema(ym)
    @show extrema(yj - ym)
    #=
    =#
#   @test isapprox(yj, ym; rtol = 0.01) # 1% seems OK for now?
# end

#=
=#
    # plot spectrograms to compare
    using Plots
    using MIRTjim: jim
    using DSP: spectrogram

    plot(yj - ym)
    xlims = (5000,5400)
p0 = plot(
    plot(yj, marker=:circle; xlims),
    plot(ym, marker=:circle; xlims),
    layout=(1,2),
); gui()
    sj = spectrogram(yj / maximum(abs, x); fs=S)
    sm = spectrogram(ym / maximum(abs, x); fs=S)
    dB = x -> max(log10.(x), -10)
    fun = (s) -> jim(s.time, s.freq, dB.(s.power)', aspect_ratio=:auto,
        ylims = (0,1800), color=:viridis, clim = (-10,0),
        yticks = 0:300:1800, yflip=false,
        xlabel="time", ylabel="freq",
        prompt = false,
    )
    sd = (; time=sj.time, freq=sj.freq, power=abs.(sj.power-sm.power))
    plot(fun(sj), fun(sm), fun(sd), p0), gui()
#   soundsc([x; ym; yj], S) # listen to compare
