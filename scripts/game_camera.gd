extends Camera2D

@onready var destroyer = $Destroyer
@onready var destroyer_shape = $Destroyer/CollisionShape2D

var player: Player = null
var viewport_size
var limit_distance = 420


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x
	
	destroyer.position.y = viewport_size.y
	var collision_shape = RectangleShape2D.new()
	collision_shape.set_size(Vector2(viewport_size.x, 100))
	destroyer_shape.shape = collision_shape


func _process(delta: float) -> void:
	if player:
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = int(player.global_position.y + limit_distance)
	
	var overlapping_areas = destroyer.get_overlapping_areas()
	if overlapping_areas.size():
		for area in overlapping_areas:
			if area is Platform:
				area.queue_free()
				print("Deleting area" + area.name)


func setup_camera(_player: Player) -> void:
	if _player:
		player = _player


func _physics_process(delta: float) -> void:
	if player:
		global_position.y = player.global_position.y
