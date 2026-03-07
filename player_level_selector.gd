extends Control

# Animations
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Main Menu
@export var Mai_Menu_Path: String = "res://Main_Menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_idle()


func play_idle() -> void:
	if animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")
	
func play_move_left() -> void:
	if animated_sprite.sprite_frames.has_animation("strafe"):
		animated_sprite.play("strafe")
	
func play_move_right() -> void:
	if animated_sprite.sprite_frames.has_animation("strafe"):
		animated_sprite.flip_h = true
		animated_sprite.play("strafe")
			
func play_move_up() -> void:
	if animated_sprite.sprite_frames.has_animation("move_up"):
		animated_sprite.play("move_up")
	
func play_move_down() -> void:
	if animated_sprite.sprite_frames.has_animation("move_down"):
		animated_sprite.play("move_down")
	
