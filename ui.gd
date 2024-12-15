extends CanvasLayer

@export var start_menu_texture: Texture2D  # Texture for the start menu background
@export var game_manager: GameManager

var current_story_index: int = 0  # Track the number of times "start" is pressed
var texture_rect: Control


func _ready():
	texture_rect = $TextureRect_start
	texture_rect.visible = true
	
	if texture_rect == null:
		print("Error: TextureRect node not found!")

func _input(event):
	# Detect "ui_accept" action (spacebar by default)
	if event.is_action_pressed("ui_accept"):
		_handle_space_pressed()
	if event.is_action_pressed("previous_slide"):
		print( "current_story_index (prev) = ", current_story_index)
		if (current_story_index == 2):
			current_story_index = 0
			_change_slide()
	
func _play_audio_new_slide():
	var	playingAudio: AudioStreamPlayer = texture_rect.find_child("AudioStreamPlayer")
	if (playingAudio):
		playingAudio.play()
		
func _handle_space_pressed():
	_change_slide()
		
func _change_slide():
	texture_rect.visible = false
	print( "current_story_index = ", current_story_index)
	
	if current_story_index == 0: 
		print("----- first page ----")
		texture_rect = $TextureRect_0
		var	label_3: Label = $TextureRect_0.find_child("Label")
		if(label_3):
			label_3.visible = true
		
	if current_story_index == 1: 
		print("----- second page ----")
		texture_rect = $TextureRect_1
		var	label_4: Label = $TextureRect_1.find_child("Label")
		if(label_4):
			label_4.visible = true

	if current_story_index == 2: 
		print("----- GAME ----")
		var	playingAudio: AudioStreamPlayer = $TextureRect_start.find_child("AudioStreamPlayer")
		if (playingAudio):
			playingAudio.stop()
			
		texture_rect = $TextureRect_3
		# _play_audio_new_slide()
		_go_into_game()
		
	texture_rect.visible = true
	current_story_index += 1
	

func _go_into_game():
	#going into game
	game_manager.load_next_scene()
	$HUDPanel.show()
	
func _on_start_game_button_pressed() -> void:
	print("START Button pressed!!")
	print( "current_story_index = ", current_story_index)
	_change_slide()
	pass # Replace with function body.


func _on_button_pressed() -> void:
	$TextureRect_start/AudioStreamPlayer.stream_paused = !$TextureRect_start/settings_menu.visible
	$TextureRect_start/settings_menu.visible = !$TextureRect_start/settings_menu.visible

func show_win():
	$"Win".show()
	
func show_lose():
	$"Lose".show()


func _on_texture_rect_0_pressed() -> void:
	_change_slide()


func _on_texture_rect_1_pressed() -> void:
	_change_slide()
