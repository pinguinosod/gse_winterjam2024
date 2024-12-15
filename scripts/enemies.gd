extends Node3D

class_name Enemy

var target_position: Vector3 = Vector3.ZERO
var pathToFollow: PackedVector2Array  #  the pathToFollow is a list of Vector2 points
var currentPathIndex = 0
@export var base_speed: float = 5.0
var speed
var perTurnAP = 15
var currentAP = perTurnAP
@export var max_range: float = 3.0
var idle = true
var inTurn = false

@export var step_sound: AudioStream
@export var attack_sound: AudioStream

var currentRoom: Room
var player: Player
var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# AudioManager.play_bg_music(step_sound)
	game_manager = $"../../../GameManager"
	speed = base_speed
	pass # Replace with function body.

func rotateTowardsDirection(direction: Vector2i):
	var rotation_deg = rotation_degrees
	if direction.y > 0:
		rotation_deg.y = 45.0
	elif direction.y < 0:
		rotation_deg.y = -135.0
	elif direction.x > 0:
		rotation_deg.y = -225.0
	elif direction.x < 0:
		rotation_deg.y = -45.0
	rotation_degrees = rotation_deg

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentPathIndex < pathToFollow.size():
		currentAP -= 1
		AudioManager.play_sfx(step_sound)
		var target_position: Vector2i = pathToFollow[currentPathIndex]# + Vector2(1,1)
		var direction = target_position - currentRoom.get_cell_position(position)
		rotateTowardsDirection(direction)
		var vec3TargetPosition = Vector3(target_position.x + 0.5, 1, target_position.y + 0.5)
		if position != vec3TargetPosition:
			position = position.move_toward(vec3TargetPosition, delta * speed)
		else:
			# Move to the next point in the path when the current one is reached
			currentPathIndex += 1
	if not idle and currentPathIndex >= pathToFollow.size():
		idle = true
		$countFallingDying.travel("Idle")
	if inTurn and currentPathIndex >= pathToFollow.size():
		speed = base_speed
		get_next_action()
	pass

# calls and processes the results of get_movement and get_next_action
func take_turn(room: Room, player: Player):
	turn_start()
	inTurn = true
	currentRoom = room
	self.player = player
	var moveTo = get_movement(room, player)
	var mapPos = room.get_cell_position(position)
	
	if moveTo.distance_to(mapPos) > 0.1:
		$countFallingDying.travel("Walk")
	idle = false
	pathToFollow = room._getPath(mapPos.x, mapPos.y, moveTo.x, moveTo.y)
	setPathToFollow(pathToFollow)
	# target_position = moveTo
	pass

func setPathToFollow(_pathToFollow: PackedVector2Array) -> void:
	#print(currentAP)
	var totalMovementCostPerTile = 1
	var longestPossiblePathSize = roundi(currentAP / totalMovementCostPerTile)
	pathToFollow = _pathToFollow.slice(0, longestPossiblePathSize + 1)
	# currentPathIndex = 0
	# Expend the players action points accordingly
	currentAP -= (pathToFollow.size() - 1) * totalMovementCostPerTile
	#print(currentAP)

# checks if valid and returns the grid field the enemy wants to move to
func get_movement(room: Room, player: Player):
	# check all fields in range of the enemy, starting with the closest to the player
	# for field in grid:
	# check if the field is not occupied
	# if grid.isFree(field):
	# return field
	
	var player_pos = room.get_cell_position(player.position)
	var choices = room.get_adjacent_cells(player_pos)
	
	return choices[randi_range(0, len(choices) - 1)]
	pass

# returns the action of the enemy for this turn
func get_next_action():
	# Check if the enemy is close enough to the player for attack
	# if player.position in self.weapon.range:
	# self.weapon.attack()
	# pass_turn()
	inTurn = false
	$countFallingDying.travel("Strike")
	if player.position.distance_to(position) <= 1:
		AudioManager.play_sfx(attack_sound)
		if not game_manager:
			game_manager = $"../../../GameManager"
		game_manager.attack_player()
	pass

func turn_start():
	currentAP = perTurnAP
