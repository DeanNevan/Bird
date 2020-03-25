extends "res://Assets/Scripts/BasicEnemy.gd"

var rotate_speed = 3
var basic_max_speed = 1300
var max_speed = 1300
var speed = 15

var can_launch_ability = true
var ability = preload("res://Assets/Scenes/Enemies/EnemyTest/Ability.tscn")
var ability_cooldown_time = 4.5
var ability_range = 1500

onready var TimerWander = Timer.new()
var wander_time = 1.5
var wander_vector : Vector2
onready var TweenVelocity = Tween.new()
onready var TimerAbility = Timer.new()
func _init():
	max_life = 2
	life = 2
	
	view_radius = 350
	view_length = 2000
	view_width = 1900
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenVelocity)
	
	add_child(TimerAbility)
	TimerAbility.one_shot = true
	TimerAbility.wait_time = ability_cooldown_time
	
	add_child(TimerWander)
	TimerWander.one_shot = true
	TimerWander.wait_time = wander_time
	TimerWander.start()
	
	Global.connect_and_detect(TimerAbility.connect("timeout", self, "_on_TimerAbility_timeout"))
	Global.connect_and_detect(TimerWander.connect("timeout", self, "_on_TimerWander_timeout"))
	Global.connect_and_detect(connect("changed_state", self, "_on_changed_state"))
	
	$ViewArea.update_CollisionShape(view_radius, view_length, view_width)
	$ViewArea.user = self
	$ViewArea.is_perspective = false
	$ViewArea.update_signal_connection()
	pass # Replace with function body.


func _draw():
	for i in path:
		draw_circle(i - global_position, 20, Color.red)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	$ViewArea.global_rotation = $Sprite.global_rotation
	$CollisionShape2D.global_rotation = $Sprite.global_rotation
	match state:
		STATE.ATTACK:
			update_path(Player.global_position - Nav.global_position)
			if can_launch_ability:
				if (Player.global_position - global_position).length() < ability_range:
					var new_ability = ability.instance()
					new_ability.global_rotation = (Player.global_position - global_position).angle()
					new_ability.global_position = global_position
					Global.add_child(new_ability)
					new_ability.start()
					can_launch_ability = false
					TimerAbility.start()
			if path.size() > 0:
				move_to(path[0], 1, delta)
				linear_velocity *= time_scale
				rotate_object($Sprite, rotate_speed, (Player.global_position - global_position).normalized(), delta * time_scale)
			else:
				change_state(STATE.WANDER)
			
			pass
		STATE.FIND:
			if path.size() > 0:
				move_to(path[0], 0.2, delta)
				linear_velocity *= time_scale
				if (global_position - (Nav.global_position + path[0])).length() < 15:
					path.remove(0)
				rotate_object($Sprite, rotate_speed, (path[0] - global_position).normalized(), delta * time_scale)
			else:
				change_state(STATE.WANDER)
			pass
		STATE.WANDER:
			path.clear()
			stop()
			rotate_object($Sprite, rotate_speed, wander_vector, delta * time_scale)
			pass
	pass

func move_to(target_global_position : Vector2, speed_scale = 1, delta = get_process_delta_time()):
	#rotate_object($Sprite, rotate_speed, (target_global_position - global_position).normalized(), delta * time_scale)
	#var direction = Vector2(cos($Sprite.global_rotation), sin($Sprite.global_rotation))
	var direction = (target_global_position - global_position).normalized()
	var change_time = (1 / speed_scale) * (Global.VELOCITY_BASIC_PARA / speed)
	TweenVelocity.interpolate_property(self, "linear_velocity", linear_velocity, max_speed * direction, change_time, Tween.TRANS_LINEAR)
	TweenVelocity.start()
	pass

func stop(_time = 1):
	TweenVelocity.interpolate_property(self, "linear_velocity", linear_velocity, Vector2(0, 0), _time, Tween.TRANS_LINEAR)
	TweenVelocity.start()
	pass

func _on_changed_state(target_state):
	if target_state == STATE.WANDER:
		last_position = global_position
		TimerWander.paused = false
		_on_TimerWander_timeout()
		#TimerWander.start()
	else:
		TimerWander.paused = true
	#print("changed_state!!:", target_state)

func entered_time_zone(time_zone_scale = 1):
	entered_time_zone_number += 1
	time_scale = time_zone_scale
	max_speed = basic_max_speed * time_scale
	
	pass

func exited_time_zone():
	entered_time_zone_number -= 1
	if entered_time_zone_number < 1:
		time_scale = 1
	max_speed = basic_max_speed * time_scale
	#linear_velocity = clamp(linear_velocity.length(), 0, max_speed) * linear_velocity.normalized()

func _on_TimerAbility_timeout():
	can_launch_ability = true

func _on_TimerWander_timeout():
	wander_vector = Vector2(1, 0).rotated(rand_range(0, 2 * PI))
	TimerWander.start()
	pass
