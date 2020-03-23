extends "res://Assets/Scripts/BasicSprite.gd"

var basic_float_range = 300
var float_range = 300

var basic_change_time = 0.05
var change_time = 0.05

var move_time = 1


var points := []
var points_size = 60
var point_index = -1
onready var FloatTimer = Timer.new()
onready var TweenPosition = Tween.new()

func _init():
	view_radius *= 1.15
	add_to_group("blue_sprited")
	color_type = Global.COLOR_TYPE.BLUE
	light_energy = 2.1

func _ready():
	for i in points_size:
		points.append(Vector2(1, 0).rotated(i * 2 * PI / points_size) * float_range)
	#print(points)
	
	add_child(FloatTimer)
	stop()
	FloatTimer.one_shot = true
	Global.connect_and_detect(FloatTimer.connect("timeout", self, "_on_FloatTimer_timeout"))
	add_child(TweenPosition)
	play_animation()
	#Global.connect_and_detect($AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_finished"))
	#$AnimationPlayer.play("default")
	pass

func _process(delta):
	#print(global_position)
	pass

func start():
	point_index = randi() % points_size
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
	point_index += 1
	if point_index > points_size - 1:
		point_index = 0
	var new_position = Player.global_position + points[point_index]
	#print("new_position!!!!")
	TweenPosition.interpolate_property(self, "position", global_position, new_position, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenPosition.start()
	pass

func play_animation():
	$AnimationPlayer.play("1")
	$AnimatedSprite.flip_h = false
	yield($AnimationPlayer, "animation_finished")
	$AnimatedSprite.play("2")
	$AnimatedSprite.flip_v = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("1")
	yield($AnimatedSprite, "animation_finished")
	$AnimationPlayer.play("2")
	$AnimatedSprite.flip_h = true
	yield($AnimationPlayer, "animation_finished")
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.play("2")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("1")
	yield($AnimatedSprite, "animation_finished")
	#yield(get_tree().create_timer(0.2), "timeout")
	play_animation()
