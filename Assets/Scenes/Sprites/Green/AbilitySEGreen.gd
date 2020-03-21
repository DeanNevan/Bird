extends Node2D

signal finished

var time = 2
var end_scale = Vector2(24, 24)
var light_time = 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
	$Light2D.energy = 2.9
	$CircleViewArea.user = Sprites.Player
	$CircleViewArea.is_perspective = true
	$CircleViewArea.update_signal_connection()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Sprites.Player.global_position
	pass

func start():
	$SE_Focus_2.play("default")
	yield($SE_Focus_2, "animation_finished")
	var TweenScale = Tween.new()
	add_child(TweenScale)
	TweenScale.interpolate_property(self, "scale", scale, end_scale, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenScale.start()
	yield(get_tree().create_timer(time / 2), "timeout")
	TweenScale.interpolate_property($Circle, "modulate", $Circle.modulate, Color($Circle.modulate.r, $Circle.modulate.g, $Circle.modulate.b, 0), time - (time / 2), Tween.TRANS_LINEAR, Tween.EASE_IN)
	yield(TweenScale, "tween_completed")
	yield(get_tree().create_timer(light_time), "timeout")
	queue_free()
	pass
