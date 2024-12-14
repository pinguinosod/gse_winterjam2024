extends Node3D

class_name AnimationController

@export var tree: AnimationTree
var state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	state_machine = tree["parameters/playback"]

func travel(state: String):
	if state_machine.get_current_node() != state:
		state_machine.travel(state)
	
