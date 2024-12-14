extends Node3D

var cameraPosition: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCameraPosition($Camera3D.position)

func setCameraPosition(newPosition: Vector3) -> void:
	cameraPosition = newPosition
	$Camera3D.position = cameraPosition
