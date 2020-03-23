extends "res://Assets/Scripts/BasicParticles.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_emit():
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	pass

func stop_emit():
	$CPUParticles2D.emitting = false
	$CPUParticles2D2.emitting = false
	pass
