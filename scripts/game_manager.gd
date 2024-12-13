extends Node

class_name GameManager

@export var combatScenesToRun: Array[CombatScene]

@export var maxEnemyPoolSize = 100
@export var enemyScene: PackedScene
@export var enemyPoolHolder: Node3D
var enemyPool: Array[Node3D]
var currentScene = 0
var currentWave = 0
var currentEnemyWave: EnemyWave
var currentCombatScene: CombatScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(maxEnemyPoolSize):
		var instance = enemyScene.instantiate()
		enemyPoolHolder.add_child(instance)
		enemyPool.append(instance)
		# instance.position = Vector3(i * (-1 ** i), 0, i * (-1 ** i))
		instance.set_process(false)
		instance.hide()
	load_next_scene()
	pass # Replace with function body.


func load_next_scene():
	if currentScene >= len(combatScenesToRun):
		return
	currentCombatScene = combatScenesToRun[currentScene]
	currentScene += 1
	currentWave = 0
	load_next_wave()

func load_next_wave():
	if currentWave >= len(currentCombatScene.enemyWaves):
		return
	currentEnemyWave = currentCombatScene.enemyWaves[currentWave]
	currentWave += 1
	load_in_enemies()
	
func load_in_enemies():
	if is_wave_active():
		return
	# TODO Figure out enemy positions
	for i in range(currentEnemyWave.basicEnemyCount):
		var enemy = spawn_next_free_enemy()
		# set hp to 1
	for i in range(currentEnemyWave.eliteEnemyCount):
		var enemy = spawn_next_free_enemy()
		# set hp to 2

func is_wave_active():
	for enemy in enemyPool:
		if enemy.visible:
			return true
	return false
	
func spawn_next_free_enemy():
	for enemy in enemyPool:
		if not enemy.visible:
			enemy.show()
			enemy.set_process(true)
			return enemy
	print("No free enemy found? Try increasing the pool size.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
