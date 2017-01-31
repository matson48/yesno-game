extends Sprite

onready var meter = get_node("meter")
onready var interpreter = get_node("../")
onready var message_window = get_node("../mwin")
onready var transition = get_node("transition")
onready var sfx = get_node("../sfx")

var changing = false
var destination_value = 0
var change_amount = 0
var frame = 0

func _ready():
    set_fixed_process(true)

func _fixed_process(dt):
    if changing:
        meter.set_value(meter.get_value()+change_amount)

        # Stop when close enough to destination value
        var value = meter.get_value()
        if change_amount < 0 and value <= destination_value:
            meter.set_value(destination_value)
            changing = false
            interpreter.advance()
        elif change_amount > 0 and value >= destination_value:
            meter.set_value(destination_value)
            changing = false
            interpreter.advance()

        if frame % 5 == 0: sfx.play("meter")
        frame += 1

func sgl_command_show_meter(arguments):
    transition.play("fade in")
    message_window.start_animation(true, true)
    transition.connect("finished", interpreter, "advance", [], CONNECT_ONESHOT)

func sgl_command_hide_meter(arguments):
    transition.play("fade out")
    message_window.start_animation(true, true)
    transition.connect("finished", interpreter, "advance", [], CONNECT_ONESHOT)

func sgl_command_reset_meter(arguments):
    meter.set_value(50)

func sgl_command_change_score(arguments):
    var amount = arguments["by"]

    if amount < 0: change_amount = -0.5
    elif amount > 0: change_amount = 0.5
    else: return

    changing = true
    destination_value = clamp(meter.get_value()+amount, 0, 100)
    frame = 0

    message_window.start_animation(true, false)
    
