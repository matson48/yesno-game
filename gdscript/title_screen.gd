extends Node

func _ready():
     get_node("title screen/new game").grab_focus()

func start_game():
     get_tree().change_scene("main.tscn")

func quit():
     get_tree().quit()

