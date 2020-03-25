extends Node2D

signal finished
signal damaged(target)

var BASIC_FIRE_RANGE = 512

var fire_range = 1536

var damage = 1

var can_rotate = true
var can_move = true

var damaged_target := []

var SE_Force = preload("res://Assets/Scenes/SE/SE_Force/SE_Force_2.tscn")
var SEs := []

onready var Player = Sprites.Player
onready var Tween1 = Tween.new()
onready var Ray = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.add_child(Ray)
	Ray.enabled = true
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
	if can_rotate:
		global_rotation = (get_global_mouse_position() - Player.global_position).angle()
	if can_move:
		global_position = Player.global_position
	Ray.cast_to = Vector2(cos(global_rotation), sin(global_rotation)) * fire_range
	Ray.global_rotation = 0
	#print(Ray.is_colliding())
	pass

func start():
	$RedParticles.start_emit()
	$SE_ShootFocus_1.visible = true
	$SE_ShootFocus_1.play("default")
	yield($SE_ShootFocus_1, "animation_finished")
	$SE_Shoot_1.visible = true
	$SE_Shoot_1.play("default")
	
	var area_range = fire_range
	var on_wall = false
	var on_wall_point = Vector2()
	var new_SE_Force
	while true:
		#print("-----")
		Ray.force_raycast_update()
		#print("位置：", Ray.global_position)
		#print()
		#print("朝向：", Ray.cast_to)
		if !Ray.is_colliding():
			#print("未接触物体")
			break
		var object = Ray.get_collider()
		if is_instance_valid(object):
			if object.type != Global.TYPE.WALL:
				#print("接触非墙物体，再次判定")
				Ray.add_exception(object)
				continue
			else:
				#print("接触墙")
				on_wall = true
				on_wall_point = Ray.get_collision_point()
				var point = Ray.get_collision_point()
				area_range = (point - global_position).length()
				#print("有效射程：", area_range)
				break
		#print("-----")
	
	if on_wall:
		new_SE_Force = SE_Force.instance()
		add_child(new_SE_Force)
		new_SE_Force.visible = false
		#new_SE_Force.play("default")
		new_SE_Force.global_position = on_wall_point
		new_SE_Force.global_rotation += PI / 2
		new_SE_Force.scale *= 0.5
	
	$SE_Shoot_1.scale.x *= area_range / fire_range
	yield(get_tree().create_timer(0.3), "timeout")
	can_rotate = false
	can_move = false
	if on_wall:
		new_SE_Force.visible = true
		new_SE_Force.speed_scale = Player.time_scale
		new_SE_Force.play("default")
	$AnimatedSprite.visible = true
	$AnimatedSprite2.visible = true
	$AnimatedSprite.play("default")
	$AnimatedSprite2.play("default")
	
	#Ray.enabled = true
	
	$AnimatedSprite.scale.x *= area_range / fire_range
	$AnimatedSprite2.scale.x *= area_range / fire_range
	
	#yield(get_tree(), "idle_frame")
		
	$AttackArea.visible = true
	$AttackArea.monitoring = true
	$AttackArea.position.x = (area_range / fire_range) * fire_range / 2
	$AttackArea/CollisionShape2D.shape.extents = Vector2((area_range / fire_range) * fire_range / 2, $AttackArea/CollisionShape2D.shape.extents.y)
	yield(get_tree(), "idle_frame")
	Ray.enabled = false
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
		if body.has_method("get_damage") and !damaged_target.has(body):
			print("hit enemy")
			var collision_point = Vector2()
			var RayDamage = RayCast2D.new()
			add_child(RayDamage)
			RayDamage.set_collision_mask_bit(2, true)
			#RayDamage.global_position = global_position
			RayDamage.global_rotation = 0
			RayDamage.cast_to = body.global_position - global_position
			RayDamage.enabled = true
			yield(get_tree(), "idle_frame")
			var is_damage = false
			var damage_point = Vector2()
			while true:
				#print("-----")
				#print("1位置：", RayDamage.global_position)
				#print("1朝向：", RayDamage.cast_to)
				RayDamage.force_raycast_update()
				if !RayDamage.is_colliding():
					#print("1未接触物体")
					break
				var object = RayDamage.get_collider()
				if object.type != Global.TYPE.ENEMY:
					#print("1未接触敌人")
					RayDamage.add_exception(object)
					continue
				else:
					if object != body:
						#print("1非接触单位")
						RayDamage.add_exception(object)
						continue
					else:
						#print("1接触单位，正在判断接触点")
						is_damage = true
						damage_point = RayDamage.get_collision_point()
						#print("1接触点：", damage_point)
						#print("-----")
						break
			if is_damage:
				var new_SE_Force = SE_Force.instance()
				add_child(new_SE_Force)
				new_SE_Force.scale *= 0.5
				new_SE_Force.visible = true
				new_SE_Force.play("default")
				new_SE_Force.speed_scale = Player.time_scale
				new_SE_Force.global_position = damage_point
				new_SE_Force.global_rotation += PI / 2
				body.get_damage(damage)
				emit_signal("damaged", body)
				damaged_target.append(body)
	pass
