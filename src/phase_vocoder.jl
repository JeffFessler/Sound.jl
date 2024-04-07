#=
phase_vocoder.jl

Julia translation of Matlab code from:
https://sethares.engr.wisc.edu/vocoders/matlabphasevocoder.html
5/2005 Bill Sethares (original Matlab version)
2022-02-26 Jeff Fessler (this Julia version)
=#

export phase_vocoder

using FFTW: fft, ifft
#using Sound: hann, findpeaks


# Process multi-channel data (e.g., stereo) one channel at a time.
function phase_vocoder(
    y::AbstractMatrix{<:Real},
    sr::Real = framerate(y) ; # sampling rate (in Hz)
    T::Type{<:AbstractFloat} = Float32,
    kwargs...
)
    mapslices(x -> phase_vocoder(x, sr; T, kwargs...), y, dims=1)::Matrix{T}
end


"""
    phase_vocoder(x, sr = framerate(x); kwargs...)

Phase vocoder for time scaling of signal `x` having sampling rate `sr` in Hz.
The time-stretch is determined by the ratio of `hopin` and `hopout` variables.
For example, `hopin=242` and `hopout=161.3333` (integers are not required)
increases the tempo by `hopin/hopout = 1.5`.
To slow down a comparable amount, choose `hopin = 161.3333`, `hopout = 242`.

# Option
* `time::Real = length(x) * sr` : total time to process (in sec)
* `hopin::Real = 121` : hop length for input
* `hopout::Real = 2*hopin` : hop length for output
* `all2pi::Any = 2π*(0:100)` multiples of 2π (used in PV-style freq search)
* `max_peak::Int = 50` : parameters for peak finding: number of peaks
* `eps_peak::Real = 0.005` : minimum height of peaks
* `nfft::Int = 2^12` : fft length
* `win::AbstractVector{<:Real} = hann(nfft)` : window
* `T::DataType = Float32` : data type
"""
function phase_vocoder(
    x::AbstractVector{<:Real},
    sr::Real = framerate(x) ; # sampling rate (in Hz)
    time::Real = length(x) * sr, # total time to process (in sec)
    hopin::Real = 121, # hop length for input
    hopout::Real = 2*hopin, # hop length for output
    all2pi::Any = 2π*(0:100), # all multiples of 2π (used in PV-style freq search)
    max_peak::Int = 50, # parameters for peak finding: number of peaks
    eps_peak::Real = 0.005, # height of peaks
    nfft::Int = 2^12, # fft length
    win::AbstractVector{<:Real} = hann(nfft), # window
    chat::Int = 0,
    T::Type{<:AbstractFloat} = Float32,
)

    nfft2 = nfft ÷ 2
    N1 = min(length(x), Int(time*sr)) # length of processed audio in samples
    yy = zeros(T, ceil(Int, hopout/hopin) * N1) # output
    lenseg = floor(Int, (N1 - nfft) / hopin) # number of nfft segments to process

    ssf = sr * (0:nfft2) / nfft # frequency vector (k/N)*S
    phold = zeros(T, nfft2+1)
    phadvance = zeros(T, nfft2+1)
    dtin = hopin / sr # time advances dt per hop for input
    dtout = hopout / sr # time advances dt per hop for output

    for k in 0:lenseg-2 # main loop - process each beat separately
        (chat > 0) && mod1(k, chat) == 1 && println(k) # show where we are
        indin = round.(Int, k * hopin .+ (1:nfft))

        s = win .* x[indin] # get this frame and take FFT
        ffts = fft(s)
        mag = abs.(ffts[1:nfft2+1])
        ph = angle.(ffts[1:nfft2+1])

        # find peaks to define spectral mapping
        peaks = findpeaks(mag, max_peak, eps_peak)
        inds = sortperm(mag[peaks[:,2]])
        peaksort = peaks[inds,:]
        pc = peaksort[:,2]

        bestf = zeros(T, size(pc))
        for tk in 1:length(pc) # estimate frequency using PV strategy
            dtheta = (ph[pc[tk]] - phold[pc[tk]]) .+ all2pi
            fest = dtheta / (2π*dtin) # see pvanalysis.m for same idea
            indf = argmin(abs.(ssf[pc[tk]] .- fest))
            bestf[tk] = fest[indf] # find best freq estimate for each row
        end

        # generate output mag and phase
        magout = copy(mag)
        phout = copy(ph)
        for tk in 1:length(pc)
            fdes = bestf[tk] # reconstruct with original frequency
            freqind = peaksort[tk,1]:peaksort[tk,3] # indices of surrounding bins

            # specify magnitude and phase of each partial
            magout[freqind] .= mag[freqind]
            phadvance[peaksort[tk,2]] += 2π * fdes * dtout
            pizero = fill(Float64(π), length(freqind))
            pcent = peaksort[tk,2] - peaksort[tk,1] + 1
            indpc = (2 - mod(pcent,2)):2:length(freqind)
            pizero[indpc] .= 0
            phout[freqind] .= phadvance[peaksort[tk,2]] .+ pizero
        end

        # reconstruct time signal (stretched or compressed)
        compl = magout .* exp.(im * phout)
        compl[nfft2+1] = ffts[nfft2+1]
        compl = [compl; reverse(conj.(compl[2:nfft2]))]
        wave = real(ifft(compl))
        phold .= ph

        indout = round.(Int, (k * hopout) .+ (1:nfft))
        yy[indout] .+= wave
    end

    return yy
end
