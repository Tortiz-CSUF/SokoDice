extends Node2D

# Animations
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")

@export var tile_size: int = 32
@export var move_duration: float = 0.12

var is_moving: bool = false


func _ready() -> void:
	position = position.snapped(Vector2(tile_size, tile_size))
	play_animation("idle")


func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return
	if event.is_action_pressed("move_left"):
		try_move(Vector2.LEFT)
	elif event.is_action_pressed("move_right"):
		try_move(Vector2.RIGHT)
	elif event.is_action_pressed("move_up"):
		try_move(Vector2.UP)
	elif event.is_action_pressed("move_down"):
		try_move(Vector2.DOWN)
	
	
func try_move(direction: Vector2) -> void:
	var target_pos: Vector2 = position + direction * tile_size
	face_direction(direction)
	
	# check dice block rtarget_pos
	var dice_block = get_dice_block_at(target_pos)
	
	if dice_block:
		if dice_block.is_moving:
			return
			
		var behind_pos := target_pos + direction * tile_size
				
		if not is_walkable(behind_pos):
			play_animation("push")
			return
			
		# save state before next move
		get_parent().save_state()
		dice_block.move_in_direction(direction, tilemap)
						
	elif not is_walkable(target_pos):	
		play_animation("push")
		return
	else:
		#save state before next move
		get_parent().save_state()
		
	is_moving = true
	play_animation(direction_to_anim(direction))
	
	var tween := create_tween()
	tween.tween_property(self, "position", target_pos, move_duration)
	tween.finished.connect(_on_move_finsihed)
	

func _on_move_finsihed() -> void:
	is_moving = false
	play_animation("idle")
	
	# increment step to movecounter 
	get_parent().add_move()

func is_walkable(target_pos: Vector2) -> bool:
	var cell := tilemap.local_to_map(tilemap.to_local(target_pos))
	print("target_pos: ", target_pos, " | cell: ", cell)
	var tile_data := tilemap.get_cell_tile_data(cell)
	print("tile_data: ", tile_data)
	if tile_data == null:
		return false
	
	print("is_wall value: ", tile_data.get_custom_data("is_wall"))
	return not tile_data.get_custom_data("is_wall")

func face_direction(direction: Vector2) -> void:
	if direction == Vector2.LEFT:
		animated_sprite.flip_h = true
	elif direction == Vector2.RIGHT:
		animated_sprite.flip_h = false

func direction_to_anim(direction: Vector2) -> String:
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		return "strafe"
	elif direction == Vector2.UP:
		return "move_up"
	else:
		return "move_down"

func play_animation(anim_name: String) -> void:
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)
		
func get_dice_block_at(target_pos: Vector2) -> Node2D:
	for dice in get_parent().get_children():
		if dice is Node2D and dice.name.begins_with("DiceBlock"):
			if dice.position == target_pos:
				return dice
	return null
