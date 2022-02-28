# hann.jl
# Hann window function


"""
    hann(x::AbstractFloat)
Hann window function (often called "Hanning" window function).
This version is `0.5 * (1 + cospi(2x))` and used in `[-0.5,+0.5]`.
https://en.wikipedia.org/wiki/Hann_function
"""
hann(x::AbstractFloat) = 0.5 * (1 + cospi(2x))


"""
    hann(n::Int)
Return vector of `n ≥ 2` samples of Hann window function
equally spaced over `[-0.5,+0.5]`.
The first and last samples are zero for `n ≥ 2`.

Caution.
Matlab has both `hann` and `hanning` functions for which
`[0; hanning(n); 0] == hann(n+2)`.

`DSP.hanning(n)` == Matlab.hann(n)`
whereas
`Sound.hann(n) == Matlab.hanning(n)`.
"""
hann(n::Int) = hann.(LinRange(-0.5, 0.5, n+2))[2:end-1]
