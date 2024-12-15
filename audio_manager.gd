extends AudioStreamPlayer3D

var sfx_player


func _ready() -> void:
	self.play()
	sfx_player = AudioStreamPlayer3D.new()
	sfx_player.volume_db = 80
	self.add_child(sfx_player)

func play_bg_music(audioTrack):
	self.stream = audioTrack
	self.play()

func stop_bg_music():
	self.stop()

func play_sfx(sfx, volume=0):
	# print("Playing sound effect!")
	sfx_player.stream = sfx
	sfx_player.volume_db = volume
	sfx_player.play()
