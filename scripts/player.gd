extends Node3D

var game_manager
var pathToFollow: PackedVector2Array  #  the pathToFollow is a list of Vector2 points
var speed: float = 10.0
var current_path_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = $"../GameManager"
	position = game_manager.get_player_start_position()
	current_path_index = 0  # Start from the beginning of the path

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_path_index < pathToFollow.size():
		var target_position: Vector2 = pathToFollow[current_path_index]# + Vector2(1,1)
		var vec3TargetPosition = Vector3(target_position.x + 0.5, 1, target_position.y + 0.5)
		if position != vec3TargetPosition:
			position = position.move_toward(vec3TargetPosition, speed * delta)
		else:
			# Move to the next point in the path when the current one is reached
			current_path_index += 1

func setPathToFollow(_pathToFollow: PackedVector2Array) -> void:
	pathToFollow = _pathToFollow
	current_path_index = 0
