extends Node3D

var target_position: Vector3 = Vector3.ZERO
var speed: float = 10.0

var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = $"../GameManager"
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Disable movement if it's the enemies turn
	if game_manager:
		if game_manager.enemyTurn():
			target_position = position
	if position != target_position:
		position = position.move_toward(target_position, speed * delta)
