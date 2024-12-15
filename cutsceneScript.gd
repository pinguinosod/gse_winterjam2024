extends GridMap
class_name CutsceneScript

var started = false

var player: AnimationTree;
var animator: AnimationNodeStateMachinePlayback

var enemy: AnimationTree
var enemyAnimator: AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"./PlayerCutsceneStrike/AnimationTree"
	animator = player["parameters/playback"]
	enemy = $"./countFallingDying/AnimationTree"
	enemyAnimator = enemy["parameters/playback"]

func play_animation():
	started = true
	animator.travel("Strike")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started and not animator.is_playing():
		enemyAnimator.travel("Death")
