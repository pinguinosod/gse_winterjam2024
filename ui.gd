extends CanvasLayer

@export var start_menu_texture: Texture2D  # Texture for the start menu background
@export var game_manager: GameManager

var current_story_index: int = 0  # Track the number of times "start" is pressed

# Cached references to nodes
var texture_rect: TextureRect
var label: Label

func _ready():
	# Print the node tree for debugging
	print_tree()
	
	# Cache references to child nodes
	texture_rect = $TextureRect_start
	label = $Label
	
	# Error handling for missing nodes
	if texture_rect == null:
		print("Error: TextureRect node not found!")
		if label == null:
			print("Error: Label node not found!")
	
	
	# Initialize the scene:  hide the Label
	if label:
		label.visible = false  # Ensure Label starts hidden
	
	# Print the initial texture name for debugging
	_print_texture_name()

func _print_texture_name():
	if texture_rect and texture_rect.texture:
		# Get the file path of the texture
		var texture_path = texture_rect.texture.resource_path
		# Extract just the file name
		var texture_name = texture_path.get_file()
		# Print the texture name to the console
		print("Current texture file: ", texture_name)
	else:
		print("No texture assigned to TextureRect.")

func _input(event):
	# Detect "ui_accept" action (spacebar by default)
	if event.is_action_pressed("ui_accept"):
		_handle_space_pressed()

func _change_slide():
	texture_rect.visible = false
	
	if current_story_index == 0: 
		print("----- first page ----")
		texture_rect = $TextureRect_0
		
	if current_story_index == 1: 
		print("----- second page ----")
		texture_rect = $TextureRect_1
	
	if current_story_index == 2: 
		print("----- GAME ----")
		var	playingAudio: AudioStreamPlayer = $TextureRect_start.find_child("AudioStreamPlayer")
		if (playingAudio):
			playingAudio.stop()
			
		texture_rect = $TextureRect_2
		_play_audio_new_slide()
		label.visible = true
		game_manager.load_next_scene()
		
	texture_rect.visible = true
	
func _play_audio_new_slide():
	var	playingAudio: AudioStreamPlayer = texture_rect.find_child("AudioStreamPlayer")
	if (playingAudio):
		playingAudio.play()
		
func _handle_space_pressed():
	print( "current_story_index = ", current_story_index)
	_change_slide()
	current_story_index += 1
		
