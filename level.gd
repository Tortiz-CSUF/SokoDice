extends Node2D

@export var level_select_path: String = "res://Level_Select.tscn"

@onready var move_counter_label: Label = $UI/VBoxContainer/MoveCounter
@onready var dice_blocks: Array = []
@onready var dice_tiles: Array = []

var move_count: int = 0
var transition: CanvasLayer

# undo/redo
var undo_stack: Array = []
var redo_stack: Array = [] 


func _ready() -> void:
	transition = $Scene_Transition
	await transition.swipe_up()
	
	for node in get_children():
		if node.name.begins_with("DiceBlock"):
			dice_blocks.append(node)
		if node.name.begins_with("DiceTile"):
			dice_tiles.append(node)
			
		print(" Dice blocks found: ", dice_blocks.size())
		print(" Dice tiles found: ", dice_tiles.size())
	
	save_state()


func _unhandled_input(event: InputEvent) -> void:
	if $Player.is_moving:
		return
	if event.is_action_pressed("ui_cancel"):
		go_to_level_select()
	if event.is_action_pressed("restart"):
		restart_level()
	if event.is_action_pressed("undo"):
		undo()
	if event.is_action_pressed("redo"):
		redo()
	
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
	
func save_state() -> void:
	var state = {
		"player": $Player.position,
		"blocks": []
	}
	
	for block in dice_blocks:
		state["blocks"].append(block.position)
	
	undo_stack.append(state)
	redo_stack.clear()

func undo() -> void:
	if undo_stack.size() < 2:
		return
		
	# save state to redo stack
	# undo_stack.pop_back()
	var current_state = undo_stack.pop_back()
	redo_stack.append(current_state)
	
	var state = undo_stack.back()
	
	restore_state(state)
		
func redo() -> void:
	if redo_stack.is_empty():
		return
	
	var state = redo_stack.pop_back()
	undo_stack.append(state)
	restore_state(state)
	
func restore_state(state: Dictionary) -> void:
	#print("Restoring player to: ", state["player"])
	#print("Restoring dice to: ", state["blocks"])
	
	$Player.position = state["player"]
	$Player.is_moving = false
	
	for i in range(dice_blocks.size()):
		var block = dice_blocks[i]
		block.cancel_movement()
		block.position = state["blocks"][i]
		block.check_on_tile()
		
	move_count = undo_stack.size() - 1
	update_move_counter()
	
