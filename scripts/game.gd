extends Node2D

@onready var platform_parent = $PlatformParent
@onready var player = $Player
@onready var viewport_size = get_viewport_rect().size

var game_camera = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")
var camera = null
var platform_width = 136.0
var platform_height = 62

#Level varibles
var start_platform_y
var y_distance_betweeb_platform = 150
var platform_per_level = 10
var generate_level_count = 0
var generate_level_offset = 400


func _ready() -> void:
	create_camera()
	start_platform_y = viewport_size.y - y_distance_betweeb_platform - platform_height
	generate_level(start_platform_y, true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	var offset_level = viewport_size.y - platform_per_level*y_distance_betweeb_platform*generate_level_count
	if player.global_position.y < offset_level + generate_level_offset:
		start_platform_y = offset_level - y_distance_betweeb_platform
		generate_level(start_platform_y, false)
	#print(offset_level)

func create_camera():
	camera = game_camera.instantiate()
	camera.setup_camera(player)
	add_child(camera)


func create_platform(position: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = position
	platform_parent.add_child(platform)
	return platform


func generate_level(_start_y, _generate_ground: bool):
	if _generate_ground:
		var platform_count = (viewport_size.x / platform_width) + 1
		for i in range(platform_count):
			create_platform(Vector2(platform_width * i, viewport_size.y - platform_height))
	
	var max_platform_x_position = viewport_size.x - platform_width - 20
	
	for i in range(platform_per_level):
		var platform_level_location: Vector2 = Vector2(0, 0)
		platform_level_location.x = randi_range(20, max_platform_x_position)
		platform_level_location.y = _start_y - y_distance_betweeb_platform*i
		create_platform(Vector2(platform_level_location))
	generate_level_count += 1
