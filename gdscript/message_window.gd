extends Node2D

onready var dialogue = get_node("box/text")
onready var ctc = get_node("ctc")
onready var name = get_node("nametag/text")
onready var interpreter = get_node("../")
onready var transition = get_node("transition")
onready var sfx = get_node("../sfx")

# Whether to do the typing effect. Initially set to false, so it won't
# try to type things before any text has been added.
var do_typing = false

var mwin_visible = false

func _ready():
    set_fixed_process(true)
    set_process_input(true)
    clear_dialogue()

func _input(event):
    if mwin_visible:
        if event.is_action_pressed("advance"):
            advance()

func _fixed_process(dt):
    if do_typing:
        var amount = dialogue.get_visible_characters()

        # When current block of text has finished typing, continue on
        # with script execution
        if amount == dialogue.get_total_character_count():
            # Order of these lines is important. Execution of script
            # events actually happens *on the advance call.* So if you
            # swap the order, the typing flag will be reset even if
            # there is more text to type. That was a fun bug to catch
            # :(
            do_typing = false
            interpreter.advance()
        else:
            amount += 1
            dialogue.set_visible_characters(amount)

func advance():
     if interpreter.pause_code == 1:
         sfx.play("advance")
         clear_dialogue()
         interpreter.advance()
     elif interpreter.pause_code == 2:
         dialogue.set_visible_characters(dialogue.get_total_character_count())          

func clear_dialogue():
    dialogue.clear()
    dialogue.set_visible_characters(0) 

func handle_text(text):
    if mwin_visible:
        dialogue.add_text(text)
        interpreter.pause(2)
        ctc.hide()
        do_typing = true
    else:
        transition.play("fade in")
        transition.connect("finished", self, "deferred_text", [text], CONNECT_ONESHOT)
        interpreter.pause(2)

func deferred_text (text):
    mwin_visible = true
    handle_text(text)

var collapsed_commands = ["choice"]
func sgl_command_paragraph(arguments):
     # Make interpreter skip paragraph command if certain other
     # commands (like a choice) are right after it
     interpreter.next()
     if interpreter.in_bounds() and interpreter.is_current_command():
         if collapsed_commands.has(interpreter.get_current().name):
             interpreter.previous()
             return
     interpreter.previous()

     interpreter.pause(1)       
     ctc.show()

func sgl_command_continue(arguments):
     interpreter.pause(1)
     ctc.show()

func sgl_command_set_name(arguments):
     var text = arguments["text"].capitalize()
     var result = ""

     # Just hardcode this case in
     if text == "Ai": 
         result = "[center][b]AI[/b][/center]"
     else:
         result = "[center]"
         for character in text:
             if character.to_upper() == character:
                 result += "[b]" + character + "[/b]"
             else:
                 result += character.to_upper()
         result += "[/center]"

     name.clear()
     name.append_bbcode(result)

func sgl_command_play_animation(arguments):
    var blocking
    if arguments.has("blocking"): 
        blocking = (arguments["blocking"] == "yes")
    else: 
        blocking = true

    var hiding
    if arguments.has("hiding"): 
        hiding = (arguments["hiding"] == "yes")
    else: 
        hiding = true

    var node = get_node(arguments["player"])

    node.play(arguments["animation"])

    if blocking:
        # Deferred prevents multiple animations from the same player
        # in a row from stalling the interpreter
        node.connect("finished", interpreter, "advance", [], CONNECT_ONESHOT|CONNECT_DEFERRED)
        interpreter.pause(3)

        if hiding and mwin_visible:
            transition.play("fade out")
            mwin_visible = false

func start_animation(blocking, hiding):
    if blocking:
        interpreter.pause(3)

        if hiding and mwin_visible:
            transition.play("fade out")
            mwin_visible = false

var italic = false
func sgl_command_toggle_italic(arguments):
     if italic:
         dialogue.push_font(dialogue.get_font("normal_font"))
         # dialogue.append_bbcode("[/i]")
         # ^ Doesn't work for some reason
         italic = false
     else:
         dialogue.push_font(dialogue.get_font("italics_font"))
         # dialogue.append_bbcode("[i]")
         italic = true


