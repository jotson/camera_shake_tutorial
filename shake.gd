extends Node

var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

enum Type {Random, Sine, Noise}
var camera_shake_type = Type.Random

var noise : OpenSimplexNoise

func _ready():
	# Generate noise for noise shake
	#
	# This is only generated once when the game starts
	# and then read over and over again
	#
	# These parameters change the shape of the noise
	# and the feel of the shake6
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20
	noise.persistence = 0.8
	

func shake(intensity, duration, type = Type.Random):
	# Set the shake parameters
	#
	# A good idea here is to add configuration settings that
	# allow the player to turn off shake
	#
	# if player_no_want:
	# 	intensity = 0
	
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
		camera_shake_type = type


func _process(delta):
	# Get the camera
	#
	# You'll need to adjust this depending on how you want to
	# keep track of the active camera in your game
	#
	# Maybe your game has two cameras, maybe it has 10, who knows?
	# Do what you like
	var camera = get_tree().current_scene.get_node("Camera2D")
	
	# Stop shaking if the camera_shake_duration timer is down to zero
	if camera_shake_duration <= 0:
		# Reset the camera when the shaking is done
		camera.offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
	
	# Subtract the elapsed time from the camera_shake_duration
	# so that it eventually ends
	#
	# You can do other fun stuff here too like have the intensity
	# decay gradually so that the shake tapers off
	camera_shake_duration = camera_shake_duration - delta
	
	# Shake it
	var offset = Vector2.ZERO
		
	if camera_shake_type == Type.Random:
		# Random shake
		# Chaos
		# Madness
		#
		# Personally, I like this best because players don't notice
		# any difference in the thick of battle when the shakes are short
		# and because it's dead simple.
		offset = Vector2(randf(), randf()) * camera_shake_intensity

	if camera_shake_type == Type.Sine:
		# Sine wave based shake
		#
		# Play around with the magic numbers to adjust the feel
		#
		# Basing the sine wave off of get_ticks_msec ensures that
		# the returned value is continuous and smooth
		offset = Vector2(sin(OS.get_ticks_msec() * 0.03), sin(OS.get_ticks_msec() * 0.07)) * camera_shake_intensity * 0.5
	
	if camera_shake_type == Type.Noise:
		# Noise based shake
		#
		# Accessing the noise based on get_ticks_msec ensures that
		# the returned value is continuous and smooth
		var noise_value_x = noise.get_noise_1d(OS.get_ticks_msec() * 0.1)
		var noise_value_y = noise.get_noise_1d(OS.get_ticks_msec() * 0.1 + 100.0)
		offset = Vector2(noise_value_x, noise_value_y) * camera_shake_intensity * 2.0
		
	camera.offset = offset
