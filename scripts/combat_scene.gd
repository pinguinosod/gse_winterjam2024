extends Resource
class_name CombatScene

@export var enemyWaves: Array[EnemyWave]
@export var doorOpensAfterTurns = 3
@export var bgm: AudioStream
@export var doorLocations: PackedVector2Array
@export var escapeRoute: PackedVector2Array

func _init():
	print("Combat Scene")
