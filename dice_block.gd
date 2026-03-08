extends Node2D

@export var tile_size: int = 32
@export var move_duration: float = 0.12
@export var pip_count: int = 1	#pip count of dice block = allowed spaces to move

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_on_tile: bool = false	
var is_moving: bool = false
var current_tween = null


func _ready() -> void:
	position = position.snapped(Vector2(tile_size, tile_size))
	update_face()
	
func setup(pips: int) -> void:
	pip_count = pips
	update_face()
	
func update_face() -> void:
	var prefix := "blue_" if is_on_tile else "grey_"
	var anim_name := prefix + '0' + str(pip_count)
	
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)

func move_in_direction(direction: Vector2, tilemap: TileMapLayer) -> void:
	if is_moving:
		return 
	
	var spaces_to_move := pip_count
	var final_pos := position
	
	# check each space
	for i in range(spaces_to_move):
		var next_pos := final_pos + direction * tile_size
		if is_cell_walkable(next_pos, tilemap):
			final_pos = next_pos
		else:
			break
		
	if final_pos == position:
		return
		
	is_moving = true
	current_tween = create_tween()
	current_tween.tween_property(self, "position", final_pos, move_duration * spaces_to_move)
	current_tween.finished.connect(_on_move_finished)
	
		
func _on_move_finished() -> void:
	is_moving = false
	check_on_tile()
		
func is_cell_walkable(target_pos: Vector2, tilemap: TileMapLayer) -> bool:
	var cell := tilemap.local_to_map(tilemap.to_local(target_pos))
	var tile_data := tilemap.get_cell_tile_data(cell)
	
	if tile_data == null:
		return false
		
	if tile_data.get_custom_data("is_wall"):
		return false
	
	for node in get_parent().get_children():
		if node != self and node.name.begins_with("DiceBlock"):
			if node.position == target_pos:
				return false
				
	return true 
		
func check_on_tile() -> void:
	is_on_tile = false
	
	for node in get_parent().get_children():
		if node.name.begins_with("DiceTile"):
			if node.position == position:
				is_on_tile = true
				break
	update_face()
		
func cancel_movement() -> void:
	
	if current_tween:
		current_tween.kill()
		current_tween = null
		
	is_moving = false
	
