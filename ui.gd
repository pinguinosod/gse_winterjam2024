extends CanvasLayer

@export var start_menu_texture: Texture2D  # Texture for the start menu background

var current_story_index: int = 0  # Track the number of times "start" is pressed

# Cached references to nodes
var texture_rect: TextureRect
var label: Label

func _ready():
	# Print the node tree for debugging
	print_tree()
	
	# Cache references to child nodes
	texture_rect = $TextureRect
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

func _handle_space_pressed():
	if texture_rect and texture_rect.visible:
		if current_story_index < 2:  # First two presses assign random textures
			texture_rect.set_random_image()  # Call the method from the TextureRect script
			current_story_index += 1
		else:
			# Hide the TextureRect and show the Label
			texture_rect.visible = false
			if label:
				label.text = "5"  # Set the Label text to "5"
				label.visible = true
	elif label and label.visible:
		# Add optional logic for when the Label is visible (e.g., reset or other behavior)
		pass
