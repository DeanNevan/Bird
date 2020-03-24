extends "res://Assets/Scripts/BasicEnemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	max_life = 2
	life = 2
	
	view_radius = 250
	view_length = 2000
	view_width = 900
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
