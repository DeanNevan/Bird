extends RigidBody2D

signal destroyed

var type = Global.TYPE.ABILITY


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func entered_time_zone(time_zone_scale = 1):
	get_parent().entered_time_zone(time_zone_scale)
	pass

func exited_time_zone():
	get_parent().exited_time_zone()

func destroyed():
	emit_signal("destroyed")
