extends Node

func _ready():
     get_node("button").grab_focus()

func go_to_title():
     get_tree().change_scene("title.tscn")



