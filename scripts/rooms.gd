extends Node3D
class_name Room

var currentRoom: GridMap
@export var offSet: Vector3
var internalGrid = []
var maxX = 26
var maxZ = 14
var AStar = AStar2D.new()
@export var countess: Node3D

var ignoreClicks = false

var game_manager: GameManager

var escapeRoute: PackedVector2Array = PackedVector2Array()

func _ready():
	countess.set_process(false)
	game_manager = $"../GameManager"
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
				if x-1 >= 0 and internalGrid[x-1][z] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x-1,z))
				if x+1 < maxX and internalGrid[x+1][z] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x+1,z))
				if z-1 >= 0 and internalGrid[x][z-1] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x,z-1))
				if z+1 < maxZ and internalGrid[x][z+1] == GridMap.INVALID_CELL_ITEM:
					AStar.connect_points(_generateID(x,z), _generateID(x,z+1))

func get_cell_position(world_position: Vector3):
	var cell = currentRoom.local_to_map(world_position)
	return Vector2i(cell.x, cell.z)
	
func get_adjacent_cells(map_pos: Vector2i):
	var all_possibilities = [Vector2i(map_pos.x - 1, map_pos.y), Vector2i(map_pos.x + 1, map_pos.y),
			Vector2i(map_pos.x, map_pos.y + 1), Vector2i(map_pos.x, map_pos.y - 1),
			Vector2i(map_pos.x - 1, map_pos.y + 1), Vector2i(map_pos.x + 1, map_pos.y - 1),
			Vector2i(map_pos.x - 1, map_pos.y - 1), Vector2i(map_pos.x + 1, map_pos.y + 1)]
	var possibilities = []
	for possibility in all_possibilities:
		if inBounds(possibility):
			possibilities.append(possibility)
	return possibilities
	
func get_random_cell_position(min_x = 1, max_x = 24, min_z = 1, max_z = 12):
	return Vector3(randi_range(min_x, max_x) + 0.5, 1, randi_range(min_z, max_z) + 0.5)

func _unhandled_input(event):
	if !ignoreClicks and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var clickPosition = get_cursor_world_position()
		var cellClicked = currentRoom.local_to_map(clickPosition)
		print("Clicked " + str(cellClicked))
		if GlobalStates.PLAYER_SELECTION_MODE ==GlobalStates.PlayerSelectionMode.WALK:
			var targetPosition = Vector3(cellClicked.x, 1, cellClicked.z)
			if Vector2(cellClicked.x, cellClicked.z) in escapeRoute:
				var playerPosition = currentRoom.local_to_map(get_node("/root/main/Player").position)
				var playerPath = _getPath(playerPosition.x, playerPosition.z, targetPosition.x, targetPosition.z)
				if get_node("/root/main/Player").canReach(playerPath):
					game_manager.load_next_scene()
			if targetPosition.x < maxX and targetPosition.x >= 1 and targetPosition.z < maxZ and targetPosition.z >= 1:
				if internalGrid[targetPosition.x][targetPosition.z] == GridMap.INVALID_CELL_ITEM:
					var playerPosition = currentRoom.local_to_map(get_node("/root/main/Player").position)
					var playerPath = _getPath(playerPosition.x, playerPosition.z, targetPosition.x, targetPosition.z)
					get_node("/root/main/Player").setPathToFollow(playerPath)
		else:
			$"../GameManager".attack_enemy_on_position(cellClicked)

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
	
func inBounds(point: Vector2i):
	return point.x > 0 and point.x < maxX - 1 and point.y > 0 and point.y < maxZ - 1

func cell_blocked(cell: Vector2):
	if not inBounds(cell):
		return true
	if not game_manager:
		game_manager = $"../GameManager"
	var actor_positions = PackedVector2Array()
	if game_manager:
		actor_positions = game_manager.get_actor_positions()
	if cell in actor_positions:
		return true
	return internalGrid[cell.x][cell.y] != GridMap.INVALID_CELL_ITEM
	
func setWinCon(escapeRoute: PackedVector2Array):
	self.escapeRoute = escapeRoute
