extends "res://Assets/Scripts/BasicSprite.gd"

#

var basic_float_range = 600
var float_range = 600

var basic_change_time = 0.1
var change_time = 0.1

var move_time = 0.2

var TweenPosition = Tween.new()
onready var FloatTimer = Timer.new()
func _init():
	view_radius *= 1.6
	add_to_group("orange_sprites")
	color_type = Global.COLOR_TYPE.ORANGE
	light_energy = 2

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
	var _index = get_tree().get_nodes_in_group("orange_sprites").find(self) + 0.5
	var sprites_size = get_tree().get_nodes_in_group("orange_sprites").size()
	#if sprites_size % 2 != 0:
		#_index -= 0.5
	var rot = ((_index - sprites_size / 2.0) / (sprites_size / 2.0)) * (PI / 3)
	#print("____")
	#print(_index)
	#print(sprites_size)
	#print(rot)
	var new_position = (Player.global_position + float_range * (get_global_mouse_position() - Player.global_position).normalized().rotated(rot))
	$Sprite.global_rotation = (get_global_mouse_position() - Player.global_position).angle()
	$Particles/CPUParticles2D.direction = -(get_global_mouse_position() - Player.global_position).normalized()
	TweenPosition.interpolate_property(self, "position", global_position, new_position, move_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenPosition.start()
	pass
