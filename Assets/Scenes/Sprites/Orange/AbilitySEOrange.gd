extends Node2D

signal finished
signal dodged
signal damaged

var dodge_time = 1.3
var qian_yao = 0.25
var damage = 1
var detect_area_radius = 150
var detect_area_time = 0.7

var ForceCircle = preload("res://Assets/Scenes/SE/SE_ForceCircle/SE_ForceCircle.tscn")
onready var Player = Sprites.Player
# Called when the node enters the scene tree for the first time.
func _ready():
	#add_child(ForceCircle)
	#ForceCircle.playing = false
	#ForceCircle.visible = false
	$Sprite.scale = Vector2()
	$Sprite2.modulate = Color.orange
	$Sprite.modulate = Color.orange
	$AnimatedSprite.modulate = Color.orange
	$Sprite.modulate.a = 1
	$Sprite2.modulate.a = 1
	$Sprite2.visible = false
	$Sprite.visible = false
	$AnimatedSprite.visible = false
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2.global_position = Player.global_position
	pass

func start():
	var _control_direction = (get_global_mouse_position() - Player.global_position).normalized()
	var Tween1 = Tween.new()
	add_child(Tween1)
	var player_light = Player.get_node("Light2D")
	var player_light_energy = player_light.energy
	var player_start_position = Player.global_position
	var player_start_velocity = Player.linear_velocity
	Player.is_controlling = false
	Player.is_controlled_by_ability = true
	Player.can_be_damaged = false
	Player.get_node("AnimatedSprite").playing = false
	Player.get_node("AnimatedSprite").frame = 15
	Player.TweenVelocity.stop_all()
	$Sprite.global_position = player_start_position
	$Sprite.visible = true
	Tween1.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color($Sprite.modulate.r, $Sprite.modulate.g, $Sprite.modulate.b, 0), 1.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Sprite, "scale", Vector2(), Vector2(3.5, 3.5), 1.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property(player_light, "energy", player_light.energy, player_light.energy * 1.7, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(get_tree().create_timer(qian_yao), "timeout")
	
	
	var DetectArea = Area2D.new()
	var DetectAreaShape = CollisionShape2D.new()
	DetectAreaShape.shape = CircleShape2D.new()
	DetectAreaShape.shape.radius = detect_area_radius
	DetectArea.add_child(DetectAreaShape)
	add_child(DetectArea)
	DetectArea.global_position = Player.global_position
	Global.connect_and_detect(DetectArea.connect("body_entered", self, "_on_DetectArea_body_entered"))
	
	#$Sprite2.global_position = Player.global_position
	$Sprite2.global_rotation = _control_direction.angle()
	$Sprite2.visible = true
	Tween1.interpolate_property($Sprite2, "modulate", $Sprite2.modulate, Color($Sprite2.modulate.r, $Sprite2.modulate.g, $Sprite2.modulate.b, 0), 1.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Sprite2, "scale", Vector2(), Vector2(1.8, 1.8), 1.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property(player_light, "energy", player_light.energy, player_light_energy, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if !Tween1.is_active():
		Tween1.start()
	
	Player.linear_velocity = _control_direction * Player.max_speed * 8
	
	Player.contact_monitor = true
	Global.connect_and_detect(Player.connect("body_entered", self, "_on_Player_body_entered"))
	
	$AnimatedSprite.global_position = Player.get_node("AnimatedSprite").global_position
	$AnimatedSprite.global_rotation = Player.linear_velocity.angle()
	$AnimatedSprite.visible = true
	$AnimatedSprite.playing = true
	$AnimatedSprite.scale = Vector2(9, 2.4)
	#var _control_direction = Player.control_direction
	#if _control_direction == Vector2():
	#	_control_direction = (get_global_mouse_position() - Player.global_position).normalized()
	#	Player.linear_velocity = _control_direction * Player.max_speed * 7
	#else:
	#	var velocity_angle = Player.get_node("AnimatedSprite").global_rotation + _control_direction.angle()
	#	var velocity_direction = Vector2(cos(velocity_angle), sin(velocity_angle))
	#	Player.linear_velocity = velocity_direction * Player.max_speed * 7
	yield(get_tree().create_timer(detect_area_time), "timeout")
	DetectArea.queue_free()
	yield(get_tree().create_timer(dodge_time - detect_area_time), "timeout")
	#Global.connect_and_detect(DetectArea.disconnect("body_entered", self, "_on_DetectArea_body_entered"))
	emit_signal("finished")
	Player.contact_monitor = false
	Player.can_be_damaged = true
	Player.linear_velocity = (get_global_mouse_position() - Player.global_position).normalized() * Player.max_speed * 1
	Player.is_controlling = true
	Player.is_controlled_by_ability = false
	Player.get_node("AnimatedSprite").playing = true
	yield(get_tree().create_timer(1), "timeout")
	
	queue_free()
	pass

func _on_DetectArea_body_entered(body):
	if body.type == Global.TYPE.PLAYER or body.type == Global.TYPE.SPRITE:
		return
	emit_signal("dodged")
	pass

func _on_Player_body_entered(body):
	if !is_instance_valid(body):
		return
	var new_ForceCircle = ForceCircle.instance()
	Global.add_child(new_ForceCircle)
	var direction = (body.global_position - Player.global_position).normalized()
	new_ForceCircle.global_position = Player.global_position + direction * Player.get_node("CollisionShape2D").shape.radius
	new_ForceCircle.global_rotation = direction.angle()
	new_ForceCircle.modulate = Color.orange
	new_ForceCircle.playing = true
	if body.type == Global.TYPE.ENEMY:
		if body.has_method("get_damage"):
			body.get_damage(damage)
			emit_signal("damaged")
