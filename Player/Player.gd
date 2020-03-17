extends RigidBody2D

signal controlled
signal cancelled_control

signal body_visible(body)
signal body_invisible(body)

signal draw_WakeFlame
signal not_draw_WakeFlame

signal sprite_changed(target_sprite_number)

var type = Global.TYPE.PLAYER

var has_updated_ViewAreaProcessCenter = false

var is_WakeFlame_drawing = false
var tail_size = 150
var points_array := []
var wake_flame_offset = Vector2()

var color = Color.white

var speed
var max_speed
var rotate_speed

var is_controlling = false

var visible_targets = []

onready var TweenVelocity = Tween.new()
onready var WakeFlame = preload("res://Assets/Scenes/WakeFlame/WakeFlame.tscn").instance()
#onready var ViewAreaLight = preload("res://Assets/Scenes/ViewArea/ViewAreaLight.tscn").instance()
onready var ViewAreaLight = $ViewArea/ViewAreaLight
func _ready():
	Sprites.Player = self
	Global.Player = self
	#Global.add_child(ViewAreaLight)
	ViewAreaLight.update_light_sprite()
	ViewAreaLight.update_shape(2500, 900)
	Global.add_child(WakeFlame)
	Global.connect_and_detect(connect("draw_WakeFlame", WakeFlame, "_on_draw"))
	Global.connect_and_detect(connect("not_draw_WakeFlame", WakeFlame, "_on_not_draw"))
	Global.connect_and_detect($AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_finished",[], 1 ))
	Global.connect_and_detect(connect("body_visible", $ViewAreaProcessCenter, "_on_ViewArea_body_visible"))
	Global.connect_and_detect(connect("body_invisible", $ViewAreaProcessCenter, "_on_ViewArea_body_invisible"))
	
	Global.connect_and_detect(Sprites.connect("changed_sprite", self, "_on_changed_sprite"))
	Global.connect_and_detect($ViewArea.connect("body_invisible", self, "_on_ViewArea_body_invisible"))
	Global.connect_and_detect($ViewArea.connect("body_visible", self, "_on_ViewArea_body_visible"))
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
		print("right_button_pressed")
		emit_signal("controlled")
		is_controlling = true
	if event.is_action_released("right_mouse_button"):
		print("right_button_released")
		emit_signal("cancelled_control")
		is_controlling = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !has_updated_ViewAreaProcessCenter:
		has_updated_ViewAreaProcessCenter = true
		$ViewAreaProcessCenter.update_connection()
	update_animation()
	if abs($AnimatedSprite.global_rotation) > PI / 2:
		$AnimatedSprite.flip_v = true
		wake_flame_offset = Vector2(0, -15)
		$CollisionShape2D.position = Vector2(0, -15)
		$ViewArea.position = Vector2(0, -15)
	else:
		wake_flame_offset = Vector2()
		$AnimatedSprite.flip_v = false
		$CollisionShape2D.position = Vector2(0, 0)
		$ViewArea.position = Vector2(0, 0)
	$CollisionShape2D.global_rotation = $AnimatedSprite.global_rotation + 90
	$ViewArea.global_rotation = $AnimatedSprite.global_rotation
	#ViewAreaLight.global_rotation = $ViewArea.global_rotation
	#ViewAreaLight.global_position = $ViewArea.global_position
	var target_direction = (get_global_mouse_position() - global_position).normalized()
	rotate_object($AnimatedSprite, rotate_speed * 0.15, target_direction, delta)
	if is_controlling:
		if !is_WakeFlame_drawing:
			is_WakeFlame_drawing = true
			emit_signal("draw_WakeFlame")
		if points_array.size() < tail_size:
			points_array.append(self.global_position + wake_flame_offset - Vector2(1, 0).rotated($AnimatedSprite.global_rotation) * 90)
		else:
			points_array.pop_front()
			points_array.append(self.global_position + wake_flame_offset - Vector2(1, 0).rotated($AnimatedSprite.global_rotation) * 90)
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
	#print("xiaoshi")
	#if visible_targets.has(body):
		#visible_targets.erase(body)
		#if body.has_method("invisible_on_screen"):
			#body.invisible_on_screen()

func _on_changed_sprite(new_type):
	color = Global.COLORS[new_type]
	modulate = (color + Color.white) / 2
	$Light2D.smooth_change_light_color((color + Color.white) / 2, 0.5)
	$Light2D.smooth_change_light_energy(0, 0.2)
	yield(get_tree().create_timer(0.2), "timeout")
	
	$Light2D.smooth_change_light_energy(1.2, 0.5)
	
	WakeFlame.modulate = (color + Color.white) / 2
