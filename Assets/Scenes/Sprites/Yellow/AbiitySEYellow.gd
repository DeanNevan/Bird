extends Node2D

signal perfect_defended(body)

var armor_value = 40

var armor_start_time = 0.3
var armor_hold_time = 3

var shock_wave_radius = 900

#var ArcArmor = preload("res://Assets/Scenes/ArcArmor/ArcArmor.tscn").instance()
var ArcArmor
onready var TimerPerfectDefend = Timer.new()
var perfect_defend_SE = preload("res://Assets/Scenes/SE/SE_Focus/SE_Focus_1.tscn")
var perfect_defend_time = 0.75
var is_perfect_defending = true
var has_perfect_defended = false
onready var Tween1 = Tween.new()
onready var Player = Sprites.Player
# Called when the node enters the scene tree for the first time.
func _ready():
	ArcArmor = $ArcArmor
	Global.connect_and_detect(ArcArmor.connect("body_entered", self, "_on_ArcArmor_body_entered"))
	add_child(TimerPerfectDefend)
	TimerPerfectDefend.one_shot = true
	Global.connect_and_detect(TimerPerfectDefend.connect("timeout", self, "_on_TimerPerfectDefend_timeout"))
	Global.connect_and_detect(connect("perfect_defended", self, "_on_perfect_defended"))
	add_child(Tween1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = (get_global_mouse_position() - Player.global_position).angle()
	global_position = Player.global_position
	pass

func start():
	ArcArmor.contact_monitor = true
	ArcArmor.contacts_reported = 3
	Tween1.interpolate_property(ArcArmor, "scale", Vector2(0.3, 0.3), Vector2(1, 1), armor_start_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	TimerPerfectDefend.start(perfect_defend_time)
	ArcArmor.change_value(armor_value, armor_start_time)
	yield(get_tree().create_timer(armor_start_time), "timeout")
	ArcArmor.change_value(0, armor_hold_time)
	yield(get_tree().create_timer(armor_hold_time), "timeout")
	ArcArmor.contact_monitor = false
	queue_free()
	pass

func _on_ArcArmor_body_entered(body):
	if !is_instance_valid(body):
		return
	if body.type == Global.TYPE.ENEMY:
		if is_perfect_defending:
			emit_signal("perfect_defended", body)
	if body.type == Global.TYPE.ABILITY:
		if is_perfect_defending:
			emit_signal("perfect_defended", body)
			if body.has_method("destroyed"):
				body.destroyed()
	pass

func _on_TimerPerfectDefend_timeout():
	is_perfect_defending = false

func _on_perfect_defended(body):
	if has_perfect_defended:
		return
	has_perfect_defended = true
	var new_SE = perfect_defend_SE.instance()
	add_child(new_SE)
	new_SE.scale = Vector2(0.9, 0.9)
	new_SE.play("default")
	new_SE.speed_scale = 2.8 * Player.time_scale
	yield(new_SE, "animation_finished")
	#Player.get_node("CollisionShape2D").disabled = true
	#yield(get_tree(), "idle_frame")
	var ShockWaveShape = $RigidBody2D/CollisionShape2D
	#var ShockWaveShape = CollisionShape2D.new()
	#ShockWaveShape.shape = CircleShape2D.new()
	#ShockWaveShape.shape.radius = 50
	#Player.add_child(ShockWaveShape)
	var Tween2 = Tween.new()
	add_child(Tween2)
	Tween2.interpolate_property($ShockWave, "scale", Vector2(1, 1), Vector2(shock_wave_radius / 230.0, shock_wave_radius / 230.0), 0.35, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween2.interpolate_property(ShockWaveShape.shape, "radius", 50, shock_wave_radius, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween2.interpolate_property($ShockWave, "modulate", $ShockWave.modulate, Color(1, 1, 1, 0), 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween2.start()
	yield(get_tree().create_timer(0.3), "timeout")
	ShockWaveShape.shape.radius = 0
	ShockWaveShape.disabled = true
	#$RigidBody2D.queue_free()
	#yield(get_tree(), "idle_frame")
	#Player.get_node("CollisionShape2D").disabled = false
	
	pass
