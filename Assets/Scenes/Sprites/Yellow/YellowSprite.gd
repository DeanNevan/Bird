extends "res://Assets/Scripts/BasicSprite.gd"

var basic_float_range = 500
var float_range = 500

var basic_change_time = 0.3
var change_time = 0.3

var move_time = 0.6

var index = 0
var sprites_count = 0
var target_vector := Vector2()

var TweenPosition = Tween.new()
onready var FloatTimer = Timer.new()
func _init():
	view_radius *= 1.45
	add_to_group("yellow_sprites")
	color_type = Global.COLOR_TYPE.YELLOW
	light_energy = 2.1

func _ready():
	add_child(TweenPosition)
	add_child(FloatTimer)
	stop()
	FloatTimer.one_shot = true
	Global.connect_and_detect(FloatTimer.connect("timeout", self, "_on_FloatTimer_timeout"))
	$AnimationPlayer.play("default")

func _process(delta):
	pass

func start():
	index = get_tree().get_nodes_in_group("yellow_sprites").find(self)
	sprites_count = get_tree().get_nodes_in_group("yellow_sprites").size()
	var _angle = (float(index) / sprites_count) * 2 * PI
	target_vector = Vector2(cos(_angle), sin(_angle)) * float_range
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
	
	var new_position = Player.global_position + target_vector
	TweenPosition.interpolate_property(self, "position", global_position, new_position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenPosition.start()
	pass
