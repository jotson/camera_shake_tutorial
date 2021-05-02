extends Node2D

func _ready():
	$AnimationPlayer.play("hit")


func shake():
	var intensity = $intensity.value / 5.0
	var duration = $duration.value / 200.0
	var type = $type.get_selected_id()
	
	# Sparklies
	$Particles2D.emitting = true
	
	# Shake it!
	Shake.shake(intensity, duration, type)


func _on_quit_pressed():
	get_tree().quit()
