#---------------------------------------------------------
# # [Sound overview](@id 01-overview)
#---------------------------------------------------------

#=
This page illustrates the Julia package
[`Sound`](https://github.com/JeffFessler/Sound.jl).

This page was generated from a single Julia file:
[01-overview.jl](@__REPO_ROOT_URL__/01-overview.jl).
=#

#md # In any such Julia documentation,
#md # you can access the source code
#md # using the "Edit on GitHub" link in the top right.

#md # The corresponding notebook can be viewed in
#md # [nbviewer](http://nbviewer.jupyter.org/) here:
#md # [`01-overview.ipynb`](@__NBVIEWER_ROOT_URL__/01-overview.ipynb),
#md # and opened in [binder](https://mybinder.org/) here:
#md # [`01-overview.ipynb`](@__BINDER_ROOT_URL__/01-overview.ipynb).


# ### Setup

# Packages needed here.

using Sound
using SampledSignals: SampleBuf
using InteractiveUtils: versioninfo


# ### Overview

# The primary purpose of this package, at least initially,
# was to provide a simple way to hear audio signals in Julia.

S = 8192 # sampling rate in Hz
x = 0.7*cos.(2π*(1:S÷2)*440/S)
y = 0.8*sin.(2π*(1:S÷2)*660/S)
sound(x, S) # monophonic

# stereo:
sound([x y], S)

# scale to unit amplitude:
soundsc([x y], S)


# Using `SampleBuf` may provide some convenience.

S = 8192 # sampling rate in Hz
x = 0.7*cos.(2π*(1:S÷2)*440/S)
y = 0.8*sin.(2π*(1:S÷2)*660/S)
sb = SampleBuf([x y], S) # stereo data
sound(sb)


# ### Reproducibility

# This page was generated with the following version of Julia:

io = IOBuffer(); versioninfo(io); split(String(take!(io)), '\n')


# And with the following package versions

import Pkg; Pkg.status()
