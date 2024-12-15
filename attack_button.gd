extends CheckButton


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		# activate player attack mode
		GlobalStates.PLAYER_SELECTION_MODE = GlobalStates.PlayerSelectionMode.ATTACK
		pass
	else:
		GlobalStates.PLAYER_SELECTION_MODE = GlobalStates.PlayerSelectionMode.WALK
		pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
