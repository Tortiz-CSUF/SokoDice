extends Node2D

@export var level_select_path: String = "res://Level_Select.tscn"

@onready var move_counter_label: Label = $UI/VBoxContainer/MoveCounter
@onready var dice_blocks: Array = []
@onready var dice_tiles: Array = []

var move_count: int = 0
var transition: CanvasLayer


func _ready() -> void:
	transition = $Scene_Transition
	await transition.swipe_up()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		go_to_level_select()
	if event.is_action_pressed("restart"):
		restart_level()
	
func add_move() -> void:
	move_count += 1
	update_move_counter()
	check_win_condition()
	
func update_move_counter() -> void:
	move_counter_label.text = "Moves: " + str(move_count)
		
func check_win_condition() -> void:
	var covered := 0
	for tile in dice_tiles:
		for block in dice_blocks:
			if block.position == tile.position:
				covered += 1
		
		if covered == dice_tiles.size():
			await transition.swipe_down()
			get_tree().change_scene_to_file(level_select_path)
	
func restart_level() -> void:
	get_tree().reload_current_scene()
	
func go_to_level_select() -> void:
	await  transition.swipe_down()
	get_tree().change_scene_to_file(level_select_path)
