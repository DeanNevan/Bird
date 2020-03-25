extends Node2D

var time = 1

var has_damaged = false

var entered_time_zone_number = 0
var time_scale = 1

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$SE_Force_7.visible = false
	$SE_Shoot_2.visible = false
	$AbilityBody/CollisionShape2D.disabled = true
	
	Global.connect_and_detect($AbilityBody.connect("body_entered", self, "_on_body_entered"))
	add_child(Tween1)
	Global.connect_and_detect($AbilityBody.connect("destroyed", self, "_on_destroyed"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	$SE_Shoot_2.play("default")
	$SE_Shoot_2.visible = true
	$AbilityBody/CollisionShape2D.disabled = false
	#Tween1.interpolate_property($AbilityBody/CollisionShape2D.shape, "extents", Vector2(0, 128), Vector2(2176 / 2, $AbilityBody/CollisionShape2D.shape.extents.y), time, Tween.TRANS_LINEAR)
	Tween1.interpolate_property($AbilityBody, "position", Vector2(), Vector2(2176 / 2, 0), time, Tween.TRANS_LINEAR)
	Tween1.start()
	yield(Tween1, "tween_completed")
	queue_free()
	pass

func _on_destroyed():
	print("destroyed")
	$SE_Force_7.position = $AbilityBody.position + Vector2(120, 0)
	$SE_Force_7.global_rotation = global_rotation
	$SE_Force_7.visible = true
	$SE_Force_7.play("default")
	Tween1.stop_all()
	$SE_Shoot_2.queue_free()
	$AbilityBody.global_position = Vector2()
	yield(get_tree(), "idle_frame")
	$AbilityBody.call_deferred("set_contact_monitor", false)
	queue_free()

func _on_body_entered(body):
	print("???")
	if !is_instance_valid(body):
		return
	if body.type == Global.TYPE.WALL or body.type == Global.TYPE.ABILITY:
		$SE_Force_7.position = $AbilityBody.position + Vector2(120, 0)
		$SE_Force_7.global_rotation = global_rotation
		$SE_Force_7.visible = true
		$SE_Force_7.play("default")
		Tween1.stop_all()
		$SE_Shoot_2.visible = false
		$AbilityBody.global_position = Vector2()
		yield(get_tree(), "idle_frame")
		$AbilityBody.call_deferred("set_contact_monitor", false)
		yield($SE_Force_7, "animation_finished")
		queue_free()
	elif body.type == Global.TYPE.PLAYER:
		body.get_damage()
		has_damaged = true
		$SE_Force_7.position = $AbilityBody.position + Vector2(120, 0)
		$SE_Force_7.global_rotation = global_rotation
		$SE_Force_7.visible = true
		$SE_Force_7.play("default")
		$AbilityBody.call_deferred("set_contact_monitor", false)
		yield($SE_Force_7, "animation_finished")
		queue_free()

func entered_time_zone(time_zone_scale = 1):
	entered_time_zone_number += 1
	time_scale = time_zone_scale
	if is_instance_valid($SE_Shoot_2):
		$SE_Shoot_2.speed_scale = time_scale
	if is_instance_valid($SE_Force_7):
		$SE_Force_7.speed_scale = time_scale
	if is_instance_valid(Tween1):
		Tween1.set_speed_scale(time_scale)
	pass

func exited_time_zone():
	entered_time_zone_number -= 1
	if entered_time_zone_number < 1:
		time_scale = 1
	if is_instance_valid($SE_Shoot_2):
		$SE_Shoot_2.speed_scale = time_scale
	if is_instance_valid($SE_Force_7):
		$SE_Force_7.speed_scale = time_scale
	if is_instance_valid(Tween1):
		Tween1.set_speed_scale(time_scale)
