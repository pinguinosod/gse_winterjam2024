extends CanvasLayer

@export var start_menu_texture: Texture2D  # Texture for the start menu background
@export var game_manager: GameManager

var current_story_index: int = 0  # Track the number of times "start" is pressed

var texture_rect: TextureRect
var label: Label

func _ready():
	texture_rect = $TextureRect_start
	texture_rect.visible = true
	
	if texture_rect == null:
		print("Error: TextureRect node not found!")
	
	# Initialize the scene: 
	if label:
		label.visible = false  # Ensure Label starts hidden

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
		
	if current_story_index == 1: 
		print("----- second page ----")
		texture_rect = $TextureRect_1
	
	if current_story_index == 2: 
		print("----- second page ----")
		texture_rect = $TextureRect_2
	
	if current_story_index == 3: 
		print("----- GAME ----")
		var	playingAudio: AudioStreamPlayer = $TextureRect_start.find_child("AudioStreamPlayer")
		if (playingAudio):
			playingAudio.stop()
			
		texture_rect = $TextureRect_3
		_play_audio_new_slide()
		if label:
			label.visible = true
		_go_into_game()
		
	texture_rect.visible = true

func _go_into_game():
	#going into game
		game_manager.load_next_scene()
	
