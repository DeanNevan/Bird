extends RigidBody2D


var type = Global.TYPE.ENEMY


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func visible_on_screen():
	$Light2D.enabled = true

func invisible_on_screen():
	$Light2D.enabled = false

func get_damage(damage):
	print("i get hurt!!!!")
	queue_free()
