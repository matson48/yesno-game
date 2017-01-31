extends Node

onready var interpreter = get_node("../")

func sgl_command_jump_to(arguments):
     interpreter.goto_label(arguments["label"])

func sgl_command_change_script(arguments):
     interpreter.auto_start = false
     interpreter.load_file("res://sglscript/" + arguments ["file"])

func sgl_command_end_game(arguments):
     get_tree().change_scene("ending.tscn")

