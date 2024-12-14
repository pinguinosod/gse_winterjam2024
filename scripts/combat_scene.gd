extends Resource
class_name CombatScene

@export var enemyWaves: Array[EnemyWave]
@export var doorOpensAfterTurns = 3
@export var bgm: AudioStream

func _init():
	print("Combat Scene")
