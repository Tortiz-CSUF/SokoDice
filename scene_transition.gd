extends CanvasLayer

@export var transition_speed: float = 1.0

@onready var animator: AnimationPlayer = $Curtain/Animator
@onready var curtain: ColorRect = $Curtain

func _ready() -> void:
	# must exist out of frame
	curtain.position.y = -get_viewport().size.y

func swipe_down():
	animator.speed_scale = transition_speed
	animator.play("swipe_down")
	await animator.animation_finished
	
func swipe_up():
	animator.speed_scale = transition_speed
	animator.play("swipe_up")
	await animator.animation_finished
