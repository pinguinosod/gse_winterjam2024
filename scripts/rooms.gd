extends Node3D


var currentRoom: GridMap
@export var offSet: Vector3

func _ready():
	currentRoom = $Room01

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clickPosition = get_cursor_world_position()
		print("click Position: ", clickPosition)
		var cellClicked = currentRoom.local_to_map(clickPosition)
		print("cell clicked: ", cellClicked)
		var targetPosition = Vector3(cellClicked.x + 0.5, 1, cellClicked.z + 0.5)
		if targetPosition.x <= 25 and targetPosition.x >= 1 and targetPosition.z <= 13 and targetPosition.z >= 1:
			get_node("/root/main/Player").target_position = targetPosition

func get_cursor_world_position() -> Vector3:
	const RAY_DISTANCE = 128
	
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not is_instance_valid(camera): return Vector3.ZERO
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * RAY_DISTANCE
	
	var ray_params := PhysicsRayQueryParameters3D.create(from, to)
	
	# Example: Set layers and mask
	ray_params.collision_mask = 1 << 0 # Only detect objects in layer 1 (bitmask)

	var ray_result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_params)
	
	return ray_result.get("position", to)# + offSet # - camera.global_position
