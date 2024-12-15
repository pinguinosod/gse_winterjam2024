extends Node

var PLAYER_SELECTION_MODE: PlayerSelectionMode = PlayerSelectionMode.WALK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

enum PlayerSelectionMode {WALK, ATTACK}
