extends CanvasLayer

@export var start_menu_texture: Texture2D  # Texture for the start menu background
@export var game_manager: GameManager

var current_story_index: int = 0  # Track the number of times "start" is pressed
var texture_rect: TextureRect

func _ready():
	texture_rect = $TextureRect_start
	texture_rect.visible = true
	
	if texture_rect == null:
		print("Error: TextureRect node not found!")

func _input(event):
	# Detect "ui_accept" action (spacebar by default)
	if event.is_action_pressed("ui_accept"):
		_handle_space_pressed()
	
func _play_audio_new_slide():
	var	playingAudio: AudioStreamPlayer = texture_rect.find_child("AudioStreamPlayer")
	if (playingAudio):
		playingAudio.play()
		
func _handle_space_pressed():
	print( "current_story_index = ", current_story_index)
	_change_slide()
	current_story_index += 1
		
func _change_slide():
	texture_rect.visible = false
	
	if current_story_index == 0: 
		print("----- first page ----")
		texture_rect = $TextureRect_0
		var	label_3: Label = $TextureRect_0.find_child("Label")
		if(label_3):
			label_3.visible = true
		
	if current_story_index == 1: 
		print("----- second page ----")
		texture_rect = $TextureRect_1

	if current_story_index == 3: 
		print("----- GAME ----")
		var	playingAudio: AudioStreamPlayer = $TextureRect_start.find_child("AudioStreamPlayer")
		if (playingAudio):
			playingAudio.stop()
			
		texture_rect = $TextureRect_3
		# _play_audio_new_slide()
		_go_into_game()
		
	texture_rect.visible = true
	

func _go_into_game():
	#going into game
	game_manager.load_next_scene()
	$"GridContainer".show()
	
func _on_start_game_button_pressed() -> void:
	print("START Button pressed!!")
	print( "current_story_index = ", current_story_index)
	_change_slide()
	current_story_index += 1
	pass # Replace with function body.


func _on_button_pressed() -> void:
	$TextureRect_start/AudioStreamPlayer.stream_paused = !$TextureRect_start/settings_menu.visible
	$TextureRect_start/settings_menu.visible = !$TextureRect_start/settings_menu.visible

func show_win():
	$"Win".show()
	
func show_lose():
	$"Lose".show()
