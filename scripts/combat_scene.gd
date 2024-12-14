extends Resource
class_name CombatScene

@export var enemyWaves: Array[EnemyWave]
@export var doorOpensAfterTurns = 3

func _init():
	print("Initialized Combat Scene")
