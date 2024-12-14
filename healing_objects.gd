extends "res://Objects.gd"

var heal_amount: int = 20

func interact() -> void:
	if is_interactive:
		print("You healed for %d health!" % heal_amount)
		queue_free()  # Remove the healing object after use
	else:
		print("This healing object is not active.")
