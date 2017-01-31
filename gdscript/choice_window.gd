extends Node

onready var interpreter = get_node("..")
onready var transition = get_node("transition")
onready var message_window = get_node("../mwin")

var yes_destination = ""
var no_destination = ""

func _ready():
    pass

func sgl_command_choice(arguments):
    transition.play("fade in")
    interpreter.pause(4)

    get_node("yes").grab_focus()

    if arguments.has("yes"):
        yes_destination = arguments["yes"]
    else:
        yes_destination = ""

    if arguments.has("no"):
        no_destination = arguments["no"]
    else:
        no_destination = ""

func click_yes():
     transition.play("choose yes")
     transition.connect("finished", self, "after_fade_out", [], CONNECT_ONESHOT)
    
     if yes_destination:
         interpreter.goto_label(yes_destination)

func click_no():
     transition.play("choose no")
     transition.connect("finished", self, "after_fade_out", [], CONNECT_ONESHOT)
    
     if no_destination:
         interpreter.goto_label(no_destination)

func after_fade_out():
    message_window.clear_dialogue()
    interpreter.advance()

