extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = [1, 2, 3]
	a.remove(0)
	print(a)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
