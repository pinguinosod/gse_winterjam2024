extends "res://Objects.gd"

var is_on: bool = false

func interact() -> void:
	if is_interactive:
		is_on = !is_on
	else:
		print("This lamp cannot be interacted with.")
