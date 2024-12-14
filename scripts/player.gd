extends Node3D

var target_position: Vector3 = Vector3.ZERO
var speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position != target_position:
		position = position.move_toward(target_position, speed * delta)
