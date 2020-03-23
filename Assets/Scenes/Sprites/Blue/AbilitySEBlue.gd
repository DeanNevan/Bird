extends Node2D


var time_zone_scale = 0.2
var time = 3.5

var effected_bodies := []

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	$TextureProgress.value = 0
	$Sprite.visible = false
	$Sprite.rotation_degrees = -90
	$Light2D.energy = 0
	$TimeZoneArea.monitoring = false
	$TimeZoneArea.monitorable = false
	Global.connect_and_detect($TimeZoneArea.connect("body_entered", self, "_on_TimeZoneArea_body_entered"))
	Global.connect_and_detect($TimeZoneArea.connect("body_exited", self, "_on_TimeZoneArea_body_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	global_position = get_global_mouse_position()
	$Sprite.visible = true
	
	Tween1.interpolate_property($TextureProgress, "value", 0, 100, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Sprite, "rotation_degrees", -90, 270, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "energy", 0, 2.5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	$Sprite.visible = false
	$TimeZoneArea.monitoring = true
	yield(get_tree().create_timer(time), "timeout")
	Tween1.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, 0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Light2D, "energy", 2.5, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	$TimeZoneArea.monitoring = false
	for i in effected_bodies:
		if is_instance_valid(i):
			if i.has_method("exited_time_zone"):
				i.exited_time_zone()
	yield(get_tree(), "idle_frame")
	queue_free()
	pass

func _on_TimeZoneArea_body_entered(body):
	if !is_instance_valid(body):
		return
	if body.type == Global.TYPE.PLAYER or body.type == Global.TYPE.SPRITE:
		return
	if body.has_method("entered_time_zone"):
		if !effected_bodies.has(body):
			effected_bodies.append(body)
		body.entered_time_zone(time_zone_scale)
	pass

func _on_TimeZoneArea_body_exited(body):
	if !is_instance_valid(body):
		return
	if body.type == Global.TYPE.PLAYER or body.type == Global.TYPE.SPRITE:
		return
	if body.has_method("exited_time_zone"):
		body.exited_time_zone()
		if effected_bodies.has(body):
			effected_bodies.erase(body)
