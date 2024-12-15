extends Node3D
class_name Player

var game_manager
var pathToFollow: PackedVector2Array  #  the pathToFollow is a list of Vector2 points
var speed: float = 5.0
var current_path_index: int = 0

var maxHP = 5
var currentHP = 5
var perTurnAP = 150
var currentAP = perTurnAP
var currentWeapon = null

var idle = true

func rotateTowardsDirection(direction: Vector2i):
	var rotation_deg = rotation_degrees
	#print(direction)
	if direction.y > 0:
		rotation_deg.y = 0.0
	elif direction.y < 0:
		rotation_deg.y = -180.0
	elif direction.x > 0:
		rotation_deg.y = 90.0
	elif direction.x < 0:
		rotation_deg.y = -90.0
	rotation_degrees = rotation_deg

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = $"../GameManager"
	game_manager.player = self
	position = game_manager.get_player_start_position()
	current_path_index = 0  # Start from the beginning of the path

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("/root/main/Rooms").toggleClickIgnore(true)
	if current_path_index == 0 and pathToFollow.size() > 0:
		$playerStrikeAnim.travel("Walk")
		idle = false
	if current_path_index < pathToFollow.size():
		var target_position: Vector2i = pathToFollow[current_path_index]# + Vector2(1,1)
		var vec3TargetPosition = Vector3(target_position.x + 0.5, 1, target_position.y + 0.5)
		var direction = target_position - get_node("/root/main/Rooms").get_cell_position(position)
		rotateTowardsDirection(direction)
		if position != vec3TargetPosition:
			position = position.move_toward(vec3TargetPosition, speed * delta)
		else:
			# Move to the next point in the path when the current one is reached
			current_path_index += 1
	else:
		get_node("/root/main/Rooms").toggleClickIgnore(game_manager.enemyTurn())
		if not idle:
			$playerStrikeAnim.travel("Idle")
			idle = true
		

func setPathToFollow(_pathToFollow: PackedVector2Array) -> void:
	#print(currentAP)
	var totalMovementCostPerTile = 1
	if currentWeapon != null:
		totalMovementCostPerTile += currentWeapon.movementCost
	var longestPossiblePathSize = roundi(currentAP / totalMovementCostPerTile)
	pathToFollow = _pathToFollow.slice(0, longestPossiblePathSize + 1)
	current_path_index = 0
	# Expend the players action points accordingly
	currentAP -= (pathToFollow.size() - 1) * totalMovementCostPerTile
	#print(currentAP)
	
func take_damage(damage: int = 1):
	currentHP -= damage
	$"CPUParticles3D".restart()
