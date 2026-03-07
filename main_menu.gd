extends Control

@export var Level_Select_Path: String = "res://Level_Select.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Scene Transition
	var transition = $Scene_Transition
	await transition.swipe_up()


func _on_start_button_pressed() -> void:
	# Loads in level select scene
	# MUST SET LEVEL SELECT SCENE ONCE CREATE
	get_tree().change_scene_to_file(Level_Select_Path)


func _on_exit_button_pressed() -> void:
	# Quits application 
	get_tree().quit()
