extends Node3D

class_name Room

var currentRoom: GridMap
@export var offSet: Vector3
var internalGrid = []
var maxX = 26
var maxZ = 14
var AStar = AStar2D.new()

var ignoreClicks = false

func _ready():
	currentRoom = $Room01
	for x in maxX:
		internalGrid.append([])
		for z in maxZ:
			var currentElement = currentRoom.get_cell_item(Vector3(x,1,z))
			internalGrid[x].append(currentElement)
			if currentElement == GridMap.INVALID_CELL_ITEM:
				AStar.add_point(_generateID(x,z), Vector2(x,z))
	print(internalGrid)
	
	for x in maxX:
		for z in maxZ:
			if internalGrid[x][z] == GridMap.INVALID_CELL_ITEM:
				if internalGrid[x-1][z] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x-1,z))
				if internalGrid[x+1][z] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x+1,z))
				if internalGrid[x][z-1] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x,z-1))
				if internalGrid[x][z+1] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x,z+1))

func get_cell_position(world_position: Vector3):
	var cell = currentRoom.local_to_map(world_position)
	return Vector3(cell.x + 0.5, 1, cell.z + 0.5)
	
func get_random_cell_position(min_x = 1, max_x = 26, min_z = 1, max_z = 14):
	return Vector3(3 + 0.5, 1, 1 + 0.5)

func _unhandled_input(event):
	if !ignoreClicks and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clickPosition = get_cursor_world_position()
		var cellClicked = currentRoom.local_to_map(clickPosition)
		var targetPosition = Vector3(cellClicked.x, 1, cellClicked.z)
		if targetPosition.x <= maxX and targetPosition.x >= 1 and targetPosition.z <= maxZ and targetPosition.z >= 1:
			if internalGrid[targetPosition.x][targetPosition.z] == GridMap.INVALID_CELL_ITEM:
				var playerPosition = currentRoom.local_to_map(get_node("/root/main/Player").position)
				var playerPath = _getPath(playerPosition.x, playerPosition.z, targetPosition.x, targetPosition.z)
				get_node("/root/main/Player").setPathToFollow(playerPath)

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

func _generateID(x,y): #generates unique id for each position - just trust the math
	return (x + y) * (x + y + 1) / 2 + y

func _getPath(x1,y1,x2,y2) -> PackedVector2Array: #Godot's built-in aStar script to find path
	var path = AStar.get_point_path(_generateID(x1, y1), _generateID(x2,y2))
	#path.remove(0) #we remove first step of path, since it's our starting point
	return path
	
func toggleClickIgnore(toggle) -> void:
	ignoreClicks = toggle;
