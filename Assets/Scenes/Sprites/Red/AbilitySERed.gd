extends Node2D

signal finished
signal damaged(target)

var BASIC_FIRE_RANGE = 512

var fire_range = 1536

var damage = 1

onready var Player = Sprites.Player
onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	
	$RedParticles.stop_emit()
	$SE_ShootFocus_1.visible = false
	
	$SE_Shoot_1.visible = false
	$AnimatedSprite.visible = false
	$AnimatedSprite2.visible = false
	
	$SE_Shoot_1.scale.x = 0.35 * fire_range / BASIC_FIRE_RANGE
	
	$AnimatedSprite.scale.x = fire_range / BASIC_FIRE_RANGE
	$AnimatedSprite2.scale.x = fire_range / BASIC_FIRE_RANGE
	
	$AttackArea.visible = false
	$AttackArea.monitoring = false
	Global.connect_and_detect($AttackArea.connect("body_entered", self, "_on_AttackArea_body_entered"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = (get_global_mouse_position() - Player.global_position).normalized().angle()
	global_position = Player.global_position

func start():
	#var _direction = (get_global_mouse_position() - Player.global_position).normalized()
	#Player.linear_velocity = Vector2()
	
	global_position = Sprites.Player.global_position
	$RedParticles.start_emit()
	$SE_ShootFocus_1.visible = true
	$SE_ShootFocus_1.play("default")
	yield($SE_ShootFocus_1, "animation_finished")
	$SE_Shoot_1.visible = true
	$SE_Shoot_1.play("default")
	yield(get_tree().create_timer(0.3), "timeout")
	$AnimatedSprite.visible = true
	$AnimatedSprite2.visible = true
	$AnimatedSprite.play("default")
	$AnimatedSprite2.play("default")
	
	$AttackArea.visible = true
	$AttackArea.monitoring = true
	$AttackArea.position.x = fire_range / 2
	$AttackArea/CollisionShape2D.shape.extents = Vector2(fire_range / 2, $AttackArea/CollisionShape2D.shape.extents.y)
	yield(get_tree(), "idle_frame")
	#Tween1.interpolate_property($AttackArea/CollisionShape2D.shape, "extents", $AttackArea/CollisionShape2D.shape.extents, Vector2(fire_range, $AttackArea/CollisionShape2D.shape.extents.y), 0.18, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#Tween1.start()
	#yield(Tween1, "tween_completed")
	
	emit_signal("finished")
	
	Tween1.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($AnimatedSprite/Light2D, "energy", 2, 0.3, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($AnimatedSprite2/Light2D, "energy", 2, 0.3, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	queue_free()
	
	pass

func _on_AttackArea_body_entered(body):
	if !is_instance_valid(body):
		return
	if body.type == Global.TYPE.PLAYER or body.type == Global.TYPE.SPRITE:
		return
	if body.type == Global.TYPE.ENEMY:
		if body.has_method("get_damage"):
			body.get_damage(damage)
			print("!!!")
			
			emit_signal("damaged", body)
	pass
