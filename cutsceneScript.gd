extends GridMap

var player: AnimationTree;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"./PlayerCutsceneStrike/AnimationTree"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_SPACE)):
		player.active = true
