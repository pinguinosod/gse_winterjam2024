extends Resource
class_name EnemyWave

@export_range(1, 100) var basicEnemyCount = 10
@export_range(0, 100) var eliteEnemyCount = 2
@export var waveName = "New Enemy Wave"
@export var waveNumber = 1
@export var spawnsInTurns = 1

func _init(basicEnemyCount = 10, eliteEnemyCount = 2, waveName = "New Enemy Wave", waveNumber = 1):
	self.basicEnemyCount = basicEnemyCount
	self.eliteEnemyCount = eliteEnemyCount
	self.waveName = waveName
	self.waveNumber = waveNumber
