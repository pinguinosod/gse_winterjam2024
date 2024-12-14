extends Node3D

class_name Enemy

var target_position: Vector3 = Vector3.ZERO
var speed: float = 10.0
var idle = true
var inTurn = false

@export var step_sound: AudioStream
@export var attack_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# AudioManager.play_bg_music(step_sound)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.distance_to(target_position) > 0.1:
		position = position.move_toward(target_position, delta)
	if not idle and position.distance_to(target_position) <= 0.1:
		idle = true
		$countFallingDying.travel("Idle")
	if inTurn and position.distance_to(target_position) <= 0.1:
		get_next_action()
	pass

func reached_target():
	return target_position.x - 0.1 < position.x and position.x < target_position.x + 0.1 and target_position.z - 0.1 < position.z and position.z < target_position.z

# calls and processes the results of get_movement and get_next_action
func take_turn(room: Room):
	inTurn = true
	var moveTo = get_movement(room)
	# TODO change that to change the grid position actually
	if moveTo.distance_to(position) > 0.1:
		$countFallingDying.travel("Walk")
	target_position = moveTo
	idle = false
	AudioManager.play_sfx(step_sound)
	pass

# checks if valid and returns the grid field the enemy wants to move to
func get_movement(room: Room):
	# check all fields in range of the enemy, starting with the closest to the player
	# for field in grid:
	# check if the field is not occupied
	# if grid.isFree(field):
	# return field
	
	return room.get_cell_position(position + Vector3(randf(), 0, randf()))
	pass

# returns the action of the enemy for this turn
func get_next_action():
	# Check if the enemy is close enough to the player for attack
	# if player.position in self.weapon.range:
	# self.weapon.attack()
	# pass_turn()
	inTurn = false
	AudioManager.play_sfx(attack_sound)
	print("Attack!")
	pass
