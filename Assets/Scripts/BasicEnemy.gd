extends RigidBody2D

signal player_visible
signal player_invisible

signal got_damged(damage)

signal changed_state(target_state)

enum STATE{
	WANDER
	ATTACK
	FIND
}

var type = Global.TYPE.ENEMY

var max_life = 1
var life = 1

var view_radius = 250
var view_length = 2000
var view_width = 900

var state = STATE.WANDER

var entered_time_zone_number = 0
var time_scale = 1

var is_player_visible = false

var allies := []
var allies_find_player_count = 0

var TweenLight = Tween.new()
var TimerFind = Timer.new()
var find_time = 2.5
var find_position := Vector2()

onready var Player = Global.Player

var Nav : Navigation2D
var path := []
var last_position := Vector2()

func _init():
	add_to_group("enemies")

func _ready():
	add_child(TimerFind)
	TimerFind.one_shot = true
	TimerFind.wait_time = find_time
	Global.connect_and_detect(TimerFind.connect("timeout", self, "_on_TimerFind_timeout"))
	
	add_child(TweenLight)
	
	Global.connect_and_detect(connect("player_visible", self, "_on_player_visible"))
	Global.connect_and_detect(connect("player_invisible", self, "_on_player_invisible"))
	
	yield(get_tree(), "idle_frame")
	invisible_on_screen()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_player_visible and state != STATE.ATTACK:
		change_state(STATE.ATTACK)
	pass

func update_path(target_position : Vector2):
	if !is_instance_valid(Nav):
		return
	path = Nav.get_simple_path(self.global_position - Nav.global_position, target_position)
	for i in path.size():
		path[i] += Nav.global_position
	path.remove(0)
	pass

func rotate_object(object, speed1, target_direction, delta):
	var present_direction = Vector2(1, 0).rotated(object.global_rotation)
	object.global_rotation = present_direction.linear_interpolate(target_direction, speed1 * delta).angle()

func change_state(target_state):
	if state != target_state:
		emit_signal("changed_state", target_state)
	state = target_state

func smooth_change_light_energy(target_enegy = 1, change_time = 0.5):
	if !TweenLight.is_inside_tree():
		return
	TweenLight.interpolate_property($Light2D, "energy", $Light2D.energy, target_enegy, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenLight.start()

func smooth_change_alpha(target_alpha = 1, change_time = 0.5):
	if !TweenLight.is_inside_tree():
		return
	TweenLight.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, target_alpha), change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenLight.start()

func visible_on_screen():
	$Light2D.enabled = true
	smooth_change_light_energy(1, 0.5)
	smooth_change_alpha(1, 0.5)

func invisible_on_screen():
	smooth_change_light_energy(0, 0.5)
	smooth_change_alpha(0, 0.5)

func get_damage(damage = 1):
	life -= damage
	print("enemy got damage")
	emit_signal("got_damged", damage)
	if life <= 0:
		queue_free()

func entered_time_zone(time_zone_scale = 1):
	entered_time_zone_number += 1
	time_scale = time_zone_scale
	pass

func exited_time_zone():
	entered_time_zone_number -= 1
	if entered_time_zone_number < 1:
		time_scale = 1

func ally_player_visible():
	allies_find_player_count += 1
	is_player_visible = true
	emit_signal("player_visible")
	pass

func ally_player_invisible():
	allies_find_player_count -= 1
	allies_find_player_count = clamp(allies_find_player_count, 0, 100)
	if allies_find_player_count == 0:
		emit_signal("player_invisible")
		is_player_visible = false
	pass

func _on_player_visible():
	#print("visible!!!")
	change_state(STATE.ATTACK)
	pass

func _on_player_invisible():
	#print("in  visible!!!")
	find_position = Player.global_position
	change_state(STATE.FIND)
	if !TimerFind.is_inside_tree():
		return
	TimerFind.start()
	pass

func _on_TimerFind_timeout():
	change_state(STATE.WANDER)

func _on_ViewArea_body_visible(body):
	if body == self:
		return
	if body.type == Global.TYPE.ENEMY:
		if !allies.has(body):
			allies.append(body)
		if is_player_visible:
			if body.has_method("ally_player_visible"):
				body.ally_player_visible()
	if body.type == Global.TYPE.PLAYER:
		for i in allies:
			if i.has_method("ally_player_visible"):
				i.ally_player_visible()
		ally_player_visible()
		pass

func _on_ViewArea_body_invisible(body):
	if body == self:
		return
	if body.type == Global.TYPE.ENEMY:
		if allies.has(body):
			allies.erase(body)
		if is_player_visible:
			if body.has_method("ally_player_invisible"):
				body.ally_player_invisible()
	if body.type == Global.TYPE.PLAYER:
		for i in allies:
			if i.has_method("ally_player_invisible"):
				i.ally_player_invisible()
		ally_player_invisible()
