extends Control

# array of tiles corresponding to levels
@onready var level_tiles: Array[Control] = [
	$"Level_Grid/Levels/Top Row/Level_01",
	$"Level_Grid/Levels/Top Row/Level_02",
	$"Level_Grid/Levels/Top Row/Level_03",
	$"Level_Grid/Levels/Botom Row/Level_04",
	$"Level_Grid/Levels/Botom Row/Level_05"
	
]

# player selector
@onready var level_selector =$Selector/Player_Level_Selector

# Main Menu
@export var Main_Menu_Path: String = "res://Main_Menu.tscn"

var selected_index: int = 0
var is_moving: bool = false

# array of files paths to level scenes.
var level_paths: Array[String] = [
	"[INSERT LEVEL 1 PATH]",
	"[INSERT LEVEL 2 PATH]",
	"[INSERT LEVEL 3 PATH]",
	"[INSERT LEVEL 4 PATH]",
	"[INSERT LEVEL 5 PATH]"
	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return
		
	if event.is_action_pressed("move_left"):
		move_left()
	elif event.is_action_pressed("move_right"):
		move_right()
	elif event.is_action_pressed("move_up"):
		move_up()
	elif event.is_action_pressed("move_down"):
		move_down()
	elif event.is_action_pressed("ui_accept"):
		load_selected_level()
	elif event.is_action_pressed("ui_cancel"):
		go_back_to_main_menu()
		
func move_left() -> void:	
	var new_index := selected_index
	
	match selected_index:
		1:
			new_index = 0
		2:
			new_index = 1
		4:
			new_index = 2
		_:
			return 
			
	move_selector_to_index(new_index, "left")
			
func move_right() -> void:	
	var new_index := selected_index
	
	match selected_index:
		0:
			new_index = 1
		1:
			new_index = 2
		3:
			new_index = 4
		_:
			return
	
	move_selector_to_index(new_index, "right")
	
func move_up() -> void:	
	var new_index := selected_index
	
	match selected_index:
		0:
			new_index = 1
		1:
			new_index = 2
		3: 
			new_index = 4
		_:
			return
	
	move_selector_to_index(new_index, "up")
	
func move_down() -> void:	
	var new_index := selected_index
	
	match selected_index:
		3:
			new_index = 0
		4:
			new_index = 1
		_: 
			return
	
	move_selector_to_index(new_index, "down")
	

func move_selector_to_index(new_index: int, direction: String) -> void:
		selected_index = new_index
		is_moving = true
		
		match direction:
			"left":
				level_selector.play_move_left()
			"right":
				level_selector.play_move_right()
			"up":
				level_selector.play_move_up()
			"down":
				level_selector.play_move_down()
				
		var target_position := get_tile_center(level_tiles[selected_index])
		
		var tween := create_tween()
		tween.tween_property(level_selector, "global_position", target_position, 0.18)
		tween.finished.connect(_on_selector_move_finished)
				
		
func _on_selector_move_finished() -> void:
	is_moving = false
	level_selector.play_idle()
	
func snap_to_current_tile() -> void:
	level_selector.global_position = get_tile_center(level_tiles[selected_index])
	level_selector.play_idle()
		
func get_tile_center(tile: Control) -> Vector2:
	var rect := tile.get_global_rect()
	return rect.position + (rect.size * 0.5)
	
func load_selected_level() -> void:
	get_tree().change_scene_to_file(level_paths[selected_index])
	
func go_back_to_main_menu() -> void:
	get_tree().change_scene_to_file(Main_Menu_Path)
	



	
