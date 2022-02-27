#=
findpeaks.jl
Julia translation from Matlab code "findPeaks4.m" from
https://sethares.engr.wisc.edu/vocoders/matlabphasevocoder.html

The comments in that file say that the Matlab version was modified
from findPeaks.m by P. Moller-Nielson 28.3.03, pm-n.
See http://www.daimi.au.dk/~pmn/sound
=#


"""
    findpeaks(amp, max_peak::Int = 50, eps_peak::Real = 0.005)
Given a real-valued vector of amplitudes `amp`,
find up to `max_peak` peaks.
Ignores any amplitudes `≤ eps_peak * maxium(amp)`.

Returns a matrix with 3 columns where each row describes a peak.
"""
function findpeaks(
    amp::AbstractVector{<:Real},
    max_peak::Int = 50, # max number of peaks
    eps_peak::Real = 0.005, # minimum relative height of peaks
)

    N = length(amp)
    n = 3:(N-1)
    peakamp = amp[n] .* (amp[n] .> amp[n .- 1]) .* (amp[n] .> amp[n .+ 1])
    peakpos = zeros(Int, max_peak)

    maxamp = maximum(peakamp)
    npeak = 0
    for p in 1:max_peak
        (m, b) = findmax(peakamp)
        if m ≤ (eps_peak * maxamp)
            break
        end
        peakpos[p] = b + 2
        peakamp[b] = 0
        npeak = p
    end

    peakpos = sort(peakpos)
    peaks = zeros(Int, npeak, 3)

    last_b = 1
    for p in 1:npeak
        b = peakpos[max_peak - npeak + p]
        first_b = last_b + 1
        if p == npeak
            last_b = N
        else
            next_b = peakpos[max_peak - npeak + p + 1]
            rel_min = argmin(amp[b:next_b])
            last_b = b + rel_min - 1
        end
        peaks[p,:] = [first_b, b, last_b]
    end

    return peaks
end
