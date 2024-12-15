extends Node3D

@export var randomSounds: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randf() < 0.001:
		if self.visible:
			AudioManager.play_sfx(randomSounds[randi_range(0, randomSounds.size() - 1)], 30)
	pass
