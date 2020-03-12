extends Node2D

signal draw_WakeFlame
signal not_draw_WakeFlame
signal body_visible(body)
signal body_invisible(body)

var type = Global.TYPE.SPRITE

var color_type = Global.COLOR_TYPE.PURPLE

var view_radius = Global.SPRITE_BASIC_VIEW_RADIUS

var is_working = false
var is_in_energy = true


#var visible_targets := []

var Player
onready var WakeFlame = preload("res://Assets/Scenes/WakeFlame/WakeFlame.tscn").instance()
onready var TweenAppear = Tween.new()
func _init():
	add_to_group("Sprites")

func _ready():
	add_child(TweenAppear)
	Global.add_child(WakeFlame)
	WakeFlame.color = Global.COLORS[color_type]
	Global.connect_and_detect(connect("draw_WakeFlame", WakeFlame, "_on_draw"))
	Global.connect_and_detect(connect("not_draw_WakeFlame", WakeFlame, "_on_not_draw"))
	$ViewArea.update_CollisionShape(view_radius)
	Global.connect_and_detect($ViewArea.connect("body_invisible", self, "_on_ViewArea_body_invisible"))
	Global.connect_and_detect($ViewArea.connect("body_visible", self, "_on_ViewArea_body_visible"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$DetectedBody.position = Vector2()

func start():
	pass

func stop():
	pass

func appear():
	visible = true
	global_position = Player.global_position
	TweenAppear.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenAppear.interpolate_property(self, "global_position", global_position, global_position + Vector2(rand_range(-50, 50), rand_range(-50, 50)), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenAppear.interpolate_property($Light2D, "energy", $Light2D.energy, 1, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenAppear.start()
	yield(TweenAppear, "tween_completed")
	
	is_working = true
	$DetectedBody/CollisionShape2D.disabled = false
	$ViewArea.monitoring = true
	#$ViewArea.monitorable = true
	$Particles.start_emit()
	
	

func disappear():
	#global_position = Player.global_position
	TweenAppear.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenAppear.interpolate_property(self, "global_position", global_position, Player.global_position, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenAppear.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenAppear.start()
	yield(TweenAppear, "tween_completed")
	visible = false
	is_working = false
	$DetectedBody/CollisionShape2D.disabled = true
	$ViewArea.monitoring = false
	$ViewArea.monitorable = false
	$Particles.stop_emit()
	pass

func _on_ViewArea_body_visible(body):
	#visible_targets.append(body)
	emit_signal("body_visible", body)
	pass

func _on_ViewArea_body_invisible(body):
	emit_signal("body_invisible", body)
	#visible_targets.erase(body)
	pass
