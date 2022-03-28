#=
gtk-record.jl
Create a 3-button GUI with "record" "stop" "play" buttons
to illustrate user control of recording.
WIP!!
=#
using Gtk
using PortAudio: PortAudioStream
using Sound: sound

# initialize global variables used throughout
const S = 44100 # sampling rate (samples/second)
const N = 1024 # buffer length
const maxtime = 300 # set maximum recording time to 5 minutes (300 seconds)
const maxtime = 20 # set maximum recording time to 5 minutes (300 seconds)
recording = nothing # flag
nsample = 0

song = Float32[] # initialize "song" as an empty vector

# callbacks

# record until maximum duration is reached, or until the global "recording"
# flag becomes false
function record_loop!(in_stream, buf)
println("in loop")
    global maxtime
    global S
    global N
    global recording
    global song
    global nsample
    Niter = floor(Int, maxtime * S / N)
println("Niter $Niter")
    for iter in 1:Niter
println("iter $iter")
        if !recording
println("break")
            break
        end
println("1")
        read!(in_stream, buf)
println("2")
        song[(iter-1)*N .+ (1:N)] = buf
println("3")
        nsample += N
#@show nsample
println("nsample $nsample")
    end
    nothing
end

function call_record(w)
    global N
    println("record")
    in_stream = PortAudioStream(1, 0), # default input device
println("buf0 N=$N")
    buf = read(in_stream, N)
println("buf1")
    global recording = true
    global song = zeros(Float32, maxtime * S)
println("loop")
    record_loop!(in_stream, buf)
    nothing
end

function call_stop(w)
    global recording = false
    global nsample
    println("stop at nsample=$nsample")
end

function call_play(w)
    println("play")
#   sound(song[1:nsample], S) # play the entire recording
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
