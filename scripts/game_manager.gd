extends Node

class_name GameManager

@export var combatScenesToRun: Array[CombatScene]

@export var maxEnemyPoolSize = 100
@export var enemyScene: PackedScene
@export var enemyPoolHolder: Node3D
@export var textDisplay: Label
@export var textDisplayDurationSeconds = 5.0

@export var nextWaveAlarm: AudioStream
@export var alwaysOn: AudioStream

var enemyPool: Array[Enemy] = []
var freeEnemies: Array[Enemy] = []
var occupiedEnemies: Array[Enemy] = []
var currentScene = 0
var currentWave = 0
var currentEnemyWave: EnemyWave
var currentCombatScene: CombatScene

var currentRoom: Room

var timeElapsed = 0.0
var secondsPassed = 0

var playerTurn = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(maxEnemyPoolSize):
		var instance = enemyScene.instantiate()
		enemyPoolHolder.add_child(instance)
		enemyPool.append(instance)
		freeEnemies.append(instance)
		# instance.position = Vector3(i * (-1 ** i), 0, i * (-1 ** i))
		instance.set_process(false)
		instance.hide()
	currentRoom = $"../Rooms"
	pass # Replace with function body.

func load_next_scene():
	if currentScene >= len(combatScenesToRun):
		return
	currentCombatScene = combatScenesToRun[currentScene]
	AudioManager.stop_bg_music()
	AudioManager.play_bg_music(currentCombatScene.bgm)
	AudioManager.play_bg_music(alwaysOn)
	currentScene += 1
	currentWave = 0
	load_next_wave()

func load_next_wave():
	if currentWave >= len(currentCombatScene.enemyWaves):
		spawn_all_waves()
		return
	currentEnemyWave = currentCombatScene.enemyWaves[currentWave]
	showText("Wave " + str(currentEnemyWave.waveNumber) + ": " + currentEnemyWave.waveName)
	currentWave += 1
	AudioManager.play_sfx(nextWaveAlarm)
	load_in_enemies()
	
func spawn_all_waves():
	for currentEnemyWave in currentCombatScene.enemyWaves:
		spawn_enemies()

func load_in_enemies():
	if is_wave_active():
		return
	spawn_enemies()
		
func spawn_enemies():
	# TODO Figure out enemy positions
	for i in range(currentEnemyWave.basicEnemyCount):
		var enemy = spawn_next_free_enemy()
		# set hp to 1
	for i in range(currentEnemyWave.eliteEnemyCount):
		var enemy = spawn_next_free_enemy()
		# set hp to 2

func is_wave_active():
	return len(occupiedEnemies) > 0
	
func spawn_next_free_enemy():
	if len(freeEnemies) > 0:
		var enemy = freeEnemies.pop_front()
		enemy.show()
		enemy.set_process(true)
		occupiedEnemies.append(enemy)
		return enemy
	print("No free enemy found? Try increasing the pool size.")
	
func clear_enemies():
	for enemy in occupiedEnemies:
		freeEnemies.append(enemy)
		enemy.hide()
		enemy.set_process(false)
	occupiedEnemies.clear()	

func free_enemy(enemy: Enemy):
	if enemy in occupiedEnemies:
		occupiedEnemies.remove_at(occupiedEnemies.find(enemy))
		freeEnemies.append(enemy)
		enemy.hide()
		enemy.set_process(false)

func showText(text: String):
	textDisplay.show()
	textDisplay.text = text
	secondsPassed = 0
	timeElapsed = 0

func enemyTurn():
	for enemy in occupiedEnemies:
		if enemy.inTurn:
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enemyTurn():
		if not playerTurn:
			#if not is_wave_active():
			#	load_next_wave()
			showText("Enemy Turn")
			for enemy in occupiedEnemies:
				enemy.take_turn(currentRoom)
		playerTurn = true
	timeElapsed += delta
	if timeElapsed > 1:
		secondsPassed += 1
		timeElapsed = 0.0
	if secondsPassed >= textDisplayDurationSeconds:
		secondsPassed = 0
		textDisplay.hide()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("end_turn") and not enemyTurn():
		playerTurn = false
	if Input.is_action_just_pressed("DEBUG_KILL_ALL") and not enemyTurn():
		clear_enemies()
	if Input.is_action_just_pressed("DEBUG_NEXT_SCENE") and not enemyTurn():
		clear_enemies()
		load_next_scene()
	
