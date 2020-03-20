extends Node2D

signal finished

var dodge_time = 1.3
var qian_yao = 0.25

onready var Player = Sprites.Player
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.scale = Vector2()
	$Sprite2.modulate = Color.orange
	$Sprite.modulate = Color.orange
	$Sprite.modulate.a = 1
	$Sprite2.modulate.a = 1
	$Sprite2.visible = false
	$Sprite.visible = false
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2.global_position = Player.global_position
	pass

func start():
	var Tween1 = Tween.new()
	add_child(Tween1)
	var player_light = Player.get_node("Light2D")
	var player_light_energy = player_light.energy
	var player_start_position = Player.global_position
	var player_start_velocity = Player.linear_velocity
	Player.is_controlling = false
	Player.is_controlled_by_ability = true
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
	#$Sprite2.global_position = Player.global_position
	$Sprite2.global_rotation = (get_global_mouse_position() - Player.global_position).normalized().angle()
	$Sprite2.visible = true
	Tween1.interpolate_property($Sprite2, "modulate", $Sprite2.modulate, Color($Sprite2.modulate.r, $Sprite2.modulate.g, $Sprite2.modulate.b, 0), 1.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($Sprite2, "scale", Vector2(), Vector2(1.8, 1.8), 1.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property(player_light, "energy", player_light.energy, player_light_energy, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if !Tween1.is_active():
		Tween1.start()
	var _control_direction = (get_global_mouse_position() - Player.global_position).normalized()
	Player.linear_velocity = _control_direction * Player.max_speed * 8
	#var _control_direction = Player.control_direction
	#if _control_direction == Vector2():
	#	_control_direction = (get_global_mouse_position() - Player.global_position).normalized()
	#	Player.linear_velocity = _control_direction * Player.max_speed * 7
	#else:
	#	var velocity_angle = Player.get_node("AnimatedSprite").global_rotation + _control_direction.angle()
	#	var velocity_direction = Vector2(cos(velocity_angle), sin(velocity_angle))
	#	Player.linear_velocity = velocity_direction * Player.max_speed * 7
	yield(get_tree().create_timer(dodge_time), "timeout")
	emit_signal("finished")
	Player.linear_velocity = (get_global_mouse_position() - Player.global_position).normalized() * Player.max_speed * 1
	Player.is_controlling = true
	Player.is_controlled_by_ability = false
	Player.get_node("AnimatedSprite").playing = true
	if Tween1.is_active():
		yield(Tween1, "tween_completed")
	queue_free()
	pass

func _on_DetectArea_body_entered(body):
	if body.type == Global.TYPE.PLAYER or body.type == Global.TYPE.SPRITE:
		return
	
	pass
