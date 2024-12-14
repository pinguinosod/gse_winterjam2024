extends Node3D

# Common properties for all objects
var is_interactive: bool = false

# Called when an interaction is attempted
func interact() -> void:
	if is_interactive:
		print("This object can be interacted with.")
	else:
		print("This object is non-interactive.")
