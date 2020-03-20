extends "res://Assets/Scripts/BasicSprite.gd"

var basic_float_range = 200
var float_range = 200

var basic_change_time = 2
var change_time = 2

onready var FloatTimer = Timer.new()
onready var TweenPosition = Tween.new()

func _init():
	view_radius *= 1.2
	add_to_group("green_sprites")
	color_type = Global.COLOR_TYPE.GREEN

func _ready():
	add_child(FloatTimer)
	stop()
	FloatTimer.one_shot = true
	Global.connect_and_detect(FloatTimer.connect("timeout", self, "_on_FloatTimer_timeout"))
	add_child(TweenPosition)
	#$AnimationPlayer.play("default")
	pass

func _process(delta):
	pass

func start():
	emit_signal("draw_WakeFlame")
	FloatTimer.paused = false
	FloatTimer.start(change_time)
	pass

func stop():
	emit_signal("not_draw_WakeFlame")
	FloatTimer.paused = true
	pass

func _on_FloatTimer_timeout():
	FloatTimer.start(change_time)
	var new_position = Player.global_position + Vector2(rand_range(-float_range, float_range), rand_range(-float_range, float_range))
	TweenPosition.interpolate_property(self, "position", global_position, new_position, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenPosition.start()
	pass
