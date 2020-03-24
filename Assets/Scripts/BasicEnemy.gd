extends RigidBody2D

signal player_visible
signal player_invisible

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

onready var TweenLight = Tween.new()
onready var TimerFind = Timer.new()
var find_time = 2.5
var find_position := Vector2()

onready var Player = Global.Player
func _ready():
	add_child(TimerFind)
	TimerFind.one_shot = true
	TimerFind.wait_time = find_time
	Global.connect_and_detect(TimerFind.connect("timeout", self, "_on_TimerFind_timeout"))
	
	add_child(TweenLight)
	$ViewArea.update_CollisionShape(view_radius, view_length, view_width)
	
	Global.connect_and_detect(connect("player_visible", self, "_on_player_visible"))
	Global.connect_and_detect(connect("player_invisible", self, "_on_player_invisible"))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		STATE.ATTACK:
			pass
		STATE.FIND:
			pass
		STATE.WANDER:
			pass
	pass

func rotate_object(object, speed1, target_direction, delta):
	var present_direction = Vector2(1, 0).rotated(object.global_rotation)
	object.global_rotation = present_direction.linear_interpolate(target_direction, speed1 * delta).angle()

func change_state(target_state):
	state = target_state

func smooth_change_light_energy(target_enegy = 1, change_time = 0.5):
	TweenLight.interpolate_property($Light2D, "energy", $Light2D.energy, target_enegy, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenLight.start()

func smooth_change_alpha(target_alpha = 1, change_time = 0.5):
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
	if allies_find_player_count > 0:
		is_player_visible = true
		emit_signal("player_visible")
	pass

func ally_player_invisible():
	allies_find_player_count -= 1
	if allies_find_player_count <= 0:
		emit_signal("player_invisible")
		is_player_visible = false
	pass

func _on_player_visible():
	change_state(STATE.ATTACK)
	pass

func _on_player_invisible():
	find_position = Player.global_position
	change_state(STATE.FIND)
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
			body.ally_player_visible()
	if body.type == Global.TYPE.PLAYER:
		for i in allies:
			i.ally_player_visible()
		pass

func _on_ViewArea_body_invisible(body):
	if body == self:
		return
	if body.type == Global.TYPE.ENEMY:
		if allies.has(body):
			allies.erase(body)
		if is_player_visible:
			body.ally_player_invisible()
	if body.type == Global.TYPE.PLAYER:
		for i in allies:
			i.ally_player_invisible()
