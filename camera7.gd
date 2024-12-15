extends Node3D

var cameraPosition: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCameraPosition($Camera3D.position)

func setCameraPosition(newPosition: Vector3) -> void:
	cameraPosition = newPosition
	$Camera3D.position = cameraPosition
	

func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	var spd = 8
	if Input.is_action_pressed("move_down"):
		movement += Vector3(-1, 0, 0)*spd*delta
	if Input.is_action_pressed("move_up"):
		movement += Vector3(1, 0, 0)*spd*delta
	if Input.is_action_pressed("move_left"):
		movement += Vector3(0, 0, -1)*spd*delta
	if Input.is_action_pressed("move_right"):
		movement += Vector3(0, 0, 1)*spd*delta
	
	if movement != Vector3.ZERO:
		setCameraPosition($Camera3D.position + movement)
