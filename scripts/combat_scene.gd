extends Resource
class_name CombatScene

@export var enemyWaves: Array[EnemyWave]
@export var doorOpensAfterTurns = 3

func _init(enemyWaves = null, doorOpensAfterTurns = 3):
	self.enemyWaves = enemyWaves
	self.doorOpensAfterTurns = doorOpensAfterTurns
