extends Node2D

signal event_started(_event)
signal event_ended(_event)

signal changed_generation_rate

var name_CN = "测试场景"
var infomation = "这是一个用于测试的场景"
var color = Color.white
onready var type = Events.TYPE.TEST


var basic_generation_value = 1
var generation_value = 1

var generation_rate = 0

#var event_area : Area2D
var Scene : PackedScene

var event_range
onready var EventTimer = Timer.new()
var in_event_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(EventTimer)
	Global.connect_and_detect(EventTimer.connect("timeout", self, "_on_EventTimer_timeout"))
	EventTimer.one_shot = false
	EventTimer.wait_time = 1
	#Global.connect_and_detect(connect("event_started", self, "_on_event_started"))
	#Global.connect_and_detect(connect("event_ended", self, "_on_event_ended"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start(pos := Vector2()):
	emit_signal("event_started", self)
	EventTimer.start()
	var new_scene = Scene.instance()
	Global.connect_and_detect(new_scene.connect("event_ended", self, "_on_event_ended"))
	new_scene.global_position = pos
	Global.add_child(new_scene)
	var event_arrow = load("res://Player/Arrow.tscn").instance()
	Global.add_child(event_arrow)
	event_arrow.show_event_position(pos, self)
	pass

func _on_event_ended():
	emit_signal("event_ended", self)
	pass

func _on_EventTimer_timeout():
	in_event_time += 1

func _on_updated_events_total_generation_value(total_value = 1):
	generation_rate = float(generation_value) / total_value
	pass
