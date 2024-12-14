extends Node3D


var currentRoom: GridMap

func _ready():
	currentRoom = $Room01

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clickPosition = get_cursor_world_position()
		print("click Position: ", clickPosition)
		var cellClicked = currentRoom.local_to_map(clickPosition)
		#print("cell clicked: ", cellClicked)

func get_cursor_world_position() -> Vector3:
	const RAY_DISTANCE = 1
	
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not is_instance_valid(camera): return Vector3.ZERO
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to: Vector3 = from + camera.project_ray_normal(mouse_pos) * RAY_DISTANCE
	
	var ray_params := PhysicsRayQueryParameters3D.create(from, to)
	var ray_result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_params)
	
	return ray_result.get("position", to) # return Vector3.ZERO if needed
