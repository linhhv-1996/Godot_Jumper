extends CharacterBody2D
class_name Player

@onready var animator = $AnimationPlayer

var speed = 300.0
var gravity = 25.0
var max_fall_velocity = 1600.0
var jump_velocity = -850
var viewport_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport_rect().size

func _process(delta: float) -> void:
	print(global_position.y)
	if velocity.y > 0:
		if animator.current_animation != "fall":
			animator.play("fall")
	elif velocity.y < 0:
		if animator.current_animation != "jump":
			animator.play("jump")

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	elif global_position.x < -margin:
		global_position.x = viewport_size.x + margin

func jump():
	velocity.y = jump_velocity
