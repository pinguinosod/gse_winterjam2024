extends GridMap
class_name CutsceneScript

var started = false
var shouldPlay = false
var done = false
var timeElapsed = 0

var player: AnimationTree;
var animator: AnimationNodeStateMachinePlayback

var enemy: AnimationTree
var enemyAnimator: AnimationNodeStateMachinePlayback

@export var attack_sound: AudioStream
@export var win_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"./PlayerCutsceneStrike/AnimationTree"
	animator = player["parameters/playback"]
	enemy = $"./countFallingDying/AnimationTree"
	enemyAnimator = enemy["parameters/playback"]

func mark_to_play():
	$"../../Camera/Camera3D".position = Vector3(3, 8, 3)
	shouldPlay = true

func play_animation():
	started = true
	animator.travel("Strike")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shouldPlay:
		timeElapsed += delta
		if timeElapsed > 1:
			play_animation()
			shouldPlay = false
	if started:
		timeElapsed += delta
		if timeElapsed > 2.5:
			AudioManager.play_sfx_override(attack_sound, 0)
			enemyAnimator.travel("Death")
			started = false
			done = true
	if done:
		timeElapsed += delta
		if timeElapsed > 5:
			$"../../GameManager".load_next_scene()
			done = false
