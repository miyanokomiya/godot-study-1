extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export var randomize_pitck = true
@export var min_pitch = 0.9
@export var max_pitch = 1.1


func play_random():
	if streams == null || streams.size() == 0:
		return
	
	if randomize_pitck:
		self.pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		self.pitch_scale = 1
	
	self.stream = streams.pick_random()
	self.play()
