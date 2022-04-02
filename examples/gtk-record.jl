#=
gtk-record.jl
Create a 3-button GUI with "record" "stop" "play" buttons
to illustrate user control of audio recording with Gtk.
=#

using Gtk: GtkGrid, GtkButton, GtkWindow, GAccessor
using Gtk: GtkCssProvider, GtkStyleProvider
using Gtk: set_gtk_property!, signal_connect, showall
using PortAudio: PortAudioStream
using Sound: sound

# initialize global variables that are used throughout
const S = 44100 # sampling rate (samples/second)
const N = 1024 # buffer length
const maxtime = 10 # maximum recording time 10 seconds (for demo)
recording = nothing # flag
nsample = 0 # count number of samples recorded
song = nothing # initialize "song"


# callbacks

"""
    record_loop!(in_stream, buf)
Record from input stream until maximum duration is reached,
or until the global "recording" flag becomes false.
"""
function record_loop!(in_stream, buf)
    global maxtime
    global S
    global N
    global recording
    global song
    global nsample
    Niter = floor(Int, maxtime * S / N)
    println("\nRecording up to Niter=$Niter ($maxtime sec).")
    for iter in 1:Niter
        if !recording
            break
        end
        read!(in_stream, buf)
        song[(iter-1)*N .+ (1:N)] = buf # save buffer to song
        nsample += N
        print("\riter=$iter/$Niter nsample=$nsample")
    end
    nothing
end


# callback function for "record" button
# The @async below is important so that the Stop button can work!
function call_record(w)
    global N
    in_stream = PortAudioStream(1, 0) # default input device
    buf = read(in_stream, N) # warm-up
    global recording = true
    global song = zeros(Float32, maxtime * S)
    @async record_loop!(in_stream, buf)
    nothing
end


# callback function for "stop" button
function call_stop(w)
    global recording = false
    global nsample
    duration = round(nsample / S, digits=2)
    sleep(0.1) # ensure the async record loop finished
    flush(stdout)
    println("\nStop at nsample=$nsample, for $duration out of $maxtime sec.")
    global song = song[1:nsample] # truncate song to the recorded duration
end


# callback function for "play" button
function call_play(w)
    println("Play")
    @async sound(song, S) # play the entire recording
end


g = GtkGrid() # initialize a grid to hold buttons
set_gtk_property!(g, :column_spacing, 10) # gaps between buttons
set_gtk_property!(g, :row_homogeneous, true) # stretch with window resize
set_gtk_property!(g, :column_homogeneous, true)


function make_button(string, callback, column, stylename, styledata)
    b = GtkButton(string)
    signal_connect((w) -> callback(w), b, "clicked")
    g[column,1] = b
    s = GtkCssProvider(data = "#$stylename {$styledata}")
    push!(GAccessor.style_context(b), GtkStyleProvider(s), 600)
    set_gtk_property!(b, :name, stylename)
    return b
end

# create buttons with appropriate callbacks, positions, and styles
br = make_button("Record", call_record, 1, "wr", "color:white; background:red;")
bs = make_button("Stop", call_stop, 2, "yb", "color:yellow; background:blue;")
bp = make_button("Play", call_play, 3, "wg", "color:white; background:green;")

win = GtkWindow("gtk3", 600, 200) # 600×200 pixel window for all the buttons
push!(win, g) # put button grid into the window
showall(win) # display the window full of buttons
nothing
