extends Node2D

signal finished

var lines_start_position := []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Global.connect_and_detect($AnimationPlayer.connect("animation_finished", self, "_on_animation_finished"))
	pass # Replace with function body.

func _draw():
	for i in lines_start_position:
		draw_line(i, Vector2(), Color(0.92, 0.55, 1, 1), 10, false)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	$AnimationPlayer.play("work")
	pass

func _on_animation_finished(name):
	var Tween1 = Tween.new()
	add_child(Tween1)
	Tween1.interpolate_property($Light2D, "energy", 0, 5, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	for i in 8:
		lines_start_position.append(Vector2(1, 0).rotated(i * PI / 4) * 296 * (scale.x) * ($Sprite.scale.x / 2.2))
		update()
		yield(get_tree().create_timer(0.07), "timeout")
		pass
	if Tween1.is_active():
		yield(Tween1, "tween_completed")
	emit_signal("finished")
	Sprites.Player.global_position = global_position
	Tween1.interpolate_property($Light2D, "energy", 5, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	queue_free()
	pass
