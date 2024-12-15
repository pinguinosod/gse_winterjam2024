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
@export var loseSound: AudioStream
@export var winSound: AudioStream

var enemyPool: Array[Enemy] = []
var freeEnemies: Array[Enemy] = []
var occupiedEnemies: Array[Enemy] = []
var currentScene = 0
var currentWave = 0
var currentTurn = 0
var currentEnemyWave: EnemyWave
var currentCombatScene: CombatScene
var currentRoom: Room

var currentEnemy: Enemy
var enemyTurnQueue: Array[Enemy] = []

var timeElapsed = 0.0
var secondsPassed = 0

var playerTurn = true

var playerStart: Vector3
var player: Player

var showingWaveText = false

func get_player_start_position():
	if not currentRoom:
		currentRoom = $"../Rooms"
	playerStart = Vector3(1.5, 1, 6.5)
	return playerStart

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
	pass # Replace with function body.

func load_next_scene():
	if currentScene >= len(combatScenesToRun):
		return
	currentCombatScene = combatScenesToRun[currentScene]
	AudioManager.stop_bg_music()
	AudioManager.play_bg_music(currentCombatScene.bgm)
	# AudioManager.play_bg_music(alwaysOn)
	currentScene += 1
	currentWave = 0
	# load_next_wave()

func load_next_wave():
	if currentWave >= len(currentCombatScene.enemyWaves):
		spawn_all_waves()
		return
	currentEnemyWave = currentCombatScene.enemyWaves[currentWave]
	showText("Wave " + str(currentEnemyWave.waveNumber) + ": " + currentEnemyWave.waveName, 3)
	showingWaveText = true
	currentWave += 1
	currentTurn = 0
	AudioManager.play_sfx(nextWaveAlarm)
	spawn_enemies()
	
func spawn_all_waves():
	for currentEnemyWave in currentCombatScene.enemyWaves:
		spawn_enemies()

func load_in_enemies():
	if is_wave_active():
		return
	spawn_enemies()
		
func spawn_enemies():
	var currentDoorIndex = 0
	# TODO Figure out enemy positions
	for i in range(currentEnemyWave.basicEnemyCount):
		if currentDoorIndex >= currentCombatScene.doorLocations.size():
			return
		var enemy = spawn_next_free_enemy_at_cell(
			currentCombatScene.doorLocations[currentDoorIndex]
		)
		currentDoorIndex += 1
		# set hp to 1
	for i in range(currentEnemyWave.eliteEnemyCount):
		if currentDoorIndex >= currentCombatScene.doorLocations.size():
			return
		var enemy = spawn_next_free_enemy_at_cell(
			currentCombatScene.doorLocations[currentDoorIndex]
		)
		currentDoorIndex += 1
		# set hp to 2

func is_wave_active():
	return len(occupiedEnemies) > 0
	
func spawn_next_free_enemy():
	if len(freeEnemies) > 0:
		var enemy = freeEnemies.pop_front()
		var enemyPos = currentRoom.get_random_cell_position()
		while (enemyPos == playerStart):
			enemyPos = currentRoom.get_random_cell_position()
		enemy.show()
		enemy.set_process(true)
		enemy.position = enemyPos
		occupiedEnemies.append(enemy)
		return enemy
	print("No free enemy found? Try increasing the pool size.")

func spawn_next_free_enemy_at_cell(cell: Vector2):
	if currentRoom.cell_blocked(cell):
		return null
	if len(freeEnemies) > 0:
		var enemy = freeEnemies.pop_front()
		var enemyPos = cell
		enemy.show()
		enemy.set_process(true)
		enemy.position = Vector3(enemyPos.x + 0.5, 1, enemyPos.y + 0.5)
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

func showText(text: String, duration: float):
	if showingWaveText:
		return
	textDisplay.show()
	textDisplay.text = text
	textDisplayDurationSeconds = duration
	secondsPassed = 0
	timeElapsed = 0

func enemyTurn():
	for enemy in occupiedEnemies:
		if enemy.inTurn:
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeElapsed += delta
	if timeElapsed > 1:
		secondsPassed += 1
		timeElapsed = 0.0
	if secondsPassed >= textDisplayDurationSeconds:
		secondsPassed = 0
		textDisplay.hide()
		if showingWaveText:
			showingWaveText = false
	if enemyTurnQueue.size() > 0 and not currentEnemy.inTurn:
		currentEnemy = enemyTurnQueue.pop_front()
		currentEnemy.take_turn(currentRoom, player)
	if not enemyTurn():
		if not playerTurn and enemyTurnQueue.size() == 0:
			#if not is_wave_active():
			#	load_next_wave()
			showText("Enemy Turn", 1.5)
			for enemy in occupiedEnemies:
				enemyTurnQueue.append(enemy)
			currentEnemy = enemyTurnQueue.pop_front()
			if currentEnemy:
				currentEnemy.take_turn(currentRoom, player)
		playerTurn = true
		player.turn_start()
	

func check_win():
	if not player:
		return
	if player.currentHP <= 0:
		#showText("You lose!", 3.5)
		$"../UI".show_lose()
		AudioManager.stop_bg_music()
		AudioManager.play_sfx(loseSound, 80)
		currentScene = 0
		clear_enemies()
			

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("end_turn") and not enemyTurn():
		playerTurn = false
		currentTurn += 1
		if currentWave < currentCombatScene.enemyWaves.size() and currentTurn >= currentCombatScene.enemyWaves[currentWave].spawnsInTurns:
			load_next_wave()
	if Input.is_action_just_pressed("end_turn") and enemyTurn():
		currentEnemy.speed *= 300
		for enemy in enemyTurnQueue:
			enemy.speed *= 300
	if Input.is_action_just_pressed("DEBUG_KILL_ALL") and not enemyTurn():
		clear_enemies()
	if Input.is_action_just_pressed("DEBUG_NEXT_SCENE") and not enemyTurn():
		clear_enemies()
		load_next_scene()

func attack_enemy_on_position(position: Vector3):
	var mapPos = currentRoom.get_cell_position(position)
	var enemyToFree = null
	for enemy in occupiedEnemies:
		var enemyPos = currentRoom.get_cell_position(enemy.position)
		if mapPos == enemyPos:
			enemyToFree = enemy
			break
	print(player.currentWeapon)
	if player.currentWeapon and enemyToFree:
		player.currentWeapon.attack()
		free_enemy(enemyToFree)

func attack_player():
	player.take_damage()
	showText("Ouch, you took 1 damage!", 1.5)
	check_win()
	
func get_actor_positions() -> PackedVector2Array:
	var result = PackedVector2Array()
	for enemy in occupiedEnemies:
		result.append(currentRoom.get_cell_position(enemy.position))
	result.append(currentRoom.get_cell_position(player.position))
	return result
	
