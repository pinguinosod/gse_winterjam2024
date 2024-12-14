extends Node3D

class_name Enemy

@export var step_sound: AudioStream
@export var attack_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# AudioManager.play_bg_music(step_sound)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# calls and processes the results of get_movement and get_next_action
func take_turn():
	var moveTo = get_movement()
	# TODO change that to change the grid position actually
	self.position += moveTo
	# AudioManager.play_sfx(step_sound)
	get_next_action()
	pass

# checks if valid and returns the grid field the enemy wants to move to
func get_movement():
	# check all fields in range of the enemy, starting with the closest to the player
	# for field in grid:
	# check if the field is not occupied
	# if grid.isFree(field):
	# return field
	
	return Vector3(randf(), 0, randf())
	pass

# returns the action of the enemy for this turn
func get_next_action():
	# Check if the enemy is close enough to the player for attack
	# if player.position in self.weapon.range:
	# self.weapon.attack()
	# pass_turn()
	
	AudioManager.play_sfx(attack_sound)
	print("Attack!")
	pass
