extends RigidBody2D

signal body_visible(body)
signal body_invisible(body)

signal draw_WakeFlame
signal not_draw_WakeFlame

signal sprite_changed(target_sprite_number)

var type = Global.TYPE.PLAYER

var is_WakeFlame_drawing = false
var tail_size = 150
var points_array := []

var color = Color.white

var speed
var max_speed
var rotate_speed

var is_controlling = false

var visible_targets = []

onready var TweenVelocity = Tween.new()
onready var WakeFlame = preload("res://Assets/Scenes/WakeFlame/WakeFlame.tscn").instance()
func _ready():
	Global.add_child(WakeFlame)
	Global.connect_and_detect(connect("draw_WakeFlame", WakeFlame, "_on_draw"))
	Global.connect_and_detect(connect("not_draw_WakeFlame", WakeFlame, "_on_not_draw"))
	Global.connect_and_detect($AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_finished",[], 1 ))
	#Global.connect_and_detect($ViewArea.connect("body_invisible", self, "_on_ViewArea_body_invisible"))
	#Global.connect_and_detect($ViewArea.connect("body_visible", self, "_on_ViewArea_body_visible"))
	add_child(TweenVelocity)
	speed = Global.PLAYER_BASIC_SPEED
	max_speed = Global.PLAYER_BASIC_MAX_SPEED
	rotate_speed = Global.PLAYER_BASIC_ROTATE_SPEED
	#max_rotate_speed = Global.PLAYER_BASIC_MAX_ROTATE_SPEED
	$ViewArea.update_CollisionShape(Global.PLAYER_BASIC_VIEW_RADIUS, Global.PLAYER_BASIC_VIEW_LENGTH, Global.PLAYER_BASIC_VIEW_WIDTH)
	$ViewArea.user = self
	$ViewArea.is_perspective = false
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("right_mouse_button"):
		is_controlling = true
	if event.is_action_released("right_mouse_button"):
		is_controlling = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_animation()
	if abs($AnimatedSprite.rotation_degrees) > 90:
		$AnimatedSprite.flip_v = true
		$CollisionShape2D.position = Vector2(0, -15)
		$ViewArea.position = Vector2(0, -15)
	else:
		$AnimatedSprite.flip_v = false
		$CollisionShape2D.position = Vector2(0, 0)
		$ViewArea.position = Vector2(0, 0)
	$CollisionShape2D.rotation_degrees = $AnimatedSprite.rotation_degrees + 90
	$ViewArea.rotation_degrees = $AnimatedSprite.rotation_degrees
	var target_direction = (get_global_mouse_position() - global_position).normalized()
	rotate_object($AnimatedSprite, rotate_speed * 0.15, target_direction, delta)
	if is_controlling:
		if !is_WakeFlame_drawing:
			is_WakeFlame_drawing = true
			emit_signal("draw_WakeFlame")
		if points_array.size() < tail_size:
			points_array.append(self.global_position)
		else:
			points_array.pop_front()
			points_array.append(self.global_position)
		WakeFlame.points_array = points_array
		var change_speed = 40.0 / speed
		$AnimatedSprite.speed_scale = 3 * sqrt(linear_velocity.length() / max_speed)
		TweenVelocity.interpolate_property(self, "linear_velocity", linear_velocity, target_direction * max_speed, change_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenVelocity.start()
	else:
		if is_WakeFlame_drawing:
			is_WakeFlame_drawing = false
			emit_signal("not_draw_WakeFlame")
		$AnimatedSprite.speed_scale = 1
		if TweenVelocity.is_active():
			TweenVelocity.stop_all()
		pass
	pass

func rotate_object(object, speed1, target_direction, delta):
	var present_direction = Vector2(1, 0).rotated(object.global_rotation)
	object.global_rotation = present_direction.linear_interpolate(target_direction, speed1 * delta).angle()

func update_animation():
	if linear_velocity.length() < max_speed / 50:
		$AnimatedSprite.animation = "idle"
	else:
		$AnimatedSprite.animation = "bird"

"""func update_animation():
	if linear_velocity.length() < 10:
		if $AnimatedSprite.animation != "to_circle" and $AnimatedSprite.animation != "circle":
			$AnimatedSprite.animation = "to_circle"
	else:
		if $AnimatedSprite.animation != "to_bird" and $AnimatedSprite.animation != "bird":
			$AnimatedSprite.animation = "to_bird"
	pass
"""

func _on_AnimatedSprite_finished():
	if $AnimatedSprite.animation == "to_circle":
		$AnimatedSprite.animation = "circle"
	if $AnimatedSprite.animation == "to_bird":
		$AnimatedSprite.animation = "bird"

func _on_ViewArea_body_visible(body):
	emit_signal("body_visible", body)
	#if !visible_targets.has(body):
		#visible_targets.append(body)
		#if body.has_method("visible_on_screen"):
			#body.visible_on_screen()

func _on_ViewArea_body_invisible(body):
	emit_signal("body_invisible", body)
	#if visible_targets.has(body):
		#visible_targets.erase(body)
		#if body.has_method("invisible_on_screen"):
			#body.invisible_on_screen()
