extends EventPlayer

func sgl_command_play_music(arguments):
    var filename = arguments["file"]
    var stream = load("res://bgm//" + filename)

    set_stream(stream)
    play()

func sgl_command_stop_music(arguments):
    stop()

