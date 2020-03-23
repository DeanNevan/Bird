extends RigidBody2D


var type = Global.TYPE.ENEMY

var entered_time_zone_number = 0
var time_scale = 1

var direction = 1
onready var Timer1 = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	visible_on_screen()
	invisible_on_screen()
	add_child(Timer1)
	Timer1.one_shot = false
	Timer1.start(1.5)
	Global.connect_and_detect(Timer1.connect("timeout", self, "_on_Timer1_timeout"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = Vector2(1, 0) * direction * 800 * time_scale

func visible_on_screen():
	$Light2D.enabled = true
	modulate.a = 1

func invisible_on_screen():
	$Light2D.enabled = false
	modulate.a = 0

func get_damage(damage):
	print("i get hurt!!!!")
	queue_free()

func entered_time_zone(time_zone_scale = 1):
	print("entered!!!")
	entered_time_zone_number += 1
	time_scale = time_zone_scale
	pass

func exited_time_zone():
	print("exited!!!")
	entered_time_zone_number -= 1
	if entered_time_zone_number < 1:
		time_scale = 1

func _on_Timer1_timeout():
	direction = -direction
