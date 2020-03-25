extends Node2D

var event
var event_position := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec = event_position - Global.Player.global_position
	global_rotation = vec.angle()
	global_position = Global.Player.global_position
	scale.x = vec.length() / event.event_range
	$Sprite.modulate = Global.COLORS[Sprites.now_type]
	pass

func show_event_position(pos, _event):
	visible = false
	event_position = pos
	event = _event
	set_process(true)
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), Events.EVENT_ARROW_TIME, Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree(), "idle_frame")
	visible = true
	yield($Tween, "tween_completed")
	queue_free()
	pass
