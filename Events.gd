extends Node2D

signal updated_events_total_generation_value(total_value)

signal event_started(event, event_position)
signal event_ended(event)
signal active_events_empty

var EVENT_ARROW_TIME = 6.5

var GAP_TIME = [1, 2]

enum TYPE{
	TEST
	NORMAL
}

var events_total_generation_value = 0

var events_array := []

var active_events := []

onready var TimerEventGenerator = Timer.new()

func _init():
	
	pass

func _ready():
	add_child(TimerEventGenerator)
	Global.connect_and_detect(TimerEventGenerator.connect("timeout", self, "_on_TimerEventGenerator_timeout"))
	TimerEventGenerator.one_shot = true
	TimerEventGenerator.autostart = false
	for i in get_children():
		if i.has_method("_on_event_ended"):
			events_array.append(i)
	for i in events_array:
		Global.connect_and_detect(i.connect("changed_generation_rate", self, "_on_events_changed_generation_rate"))
		Global.connect_and_detect(i.connect("event_started", self, "_on_event_started"))
		Global.connect_and_detect(i.connect("event_ended", self, "_on_event_ended"))
		Global.connect_and_detect(connect("updated_events_total_generation_value", i, "_on_updated_events_total_generation_value"))
	update_events_total_generation_value()
	Global.connect_and_detect(connect("active_events_empty", self, "_on_active_events_empty"))

#func _process(delta):
#	pass

func judge_events():
	var random_result = randf()
	var _rate_list := {}
	for i in events_array:
		_rate_list[i] = i.generation_rate
	var _sort_array = sort_list_to_array(_rate_list)
	_sort_array.invert()
	
	var event
	for i in _sort_array:
		random_result -= i.generation_rate
		if random_result <= 0:
			event = i
			break
	if event == null:
		print("judge events generation failed")
		return false
	var pos = Global.Player.global_position + Vector2(1, 0).rotated(rand_range(0, 2*PI)) * event.event_range
	event.start(pos)
	$EventsGUI.display(event)
	emit_signal("event_started", event, pos)
	print("judge events generation succeeded", event)
	pass

func update_events_total_generation_value():
	events_total_generation_value = 0
	for i in events_array:
		events_total_generation_value += i.generation_value
	emit_signal("updated_events_total_generation_value", events_total_generation_value)
	#	events_generation_rate_list[i] = i.generation_rate
	#events_generation_rate_array = sort_list_to_array(events_generation_rate_list)

func sort_list_to_array(list : Dictionary):
	var _array = []
	var _values = list.values()
	_values.sort()
	_values.invert()
	for value in _values:
		for i in list:
			if list.get(i) == value and !_array.has(i):
				_array.append(i)
	return _array

func _on_events_changed_generation_rate():
	update_events_total_generation_value()

func _on_event_started(_evnet):
	if !active_events.has(_evnet):
		active_events.append(_evnet)
func _on_event_ended(_evnet):
	if active_events.has(_evnet):
		emit_signal("event_ended", _evnet)
		active_events.erase(_evnet)
		if active_events.size() == 0:
			emit_signal("active_events_empty")

func _on_active_events_empty():
	TimerEventGenerator.start(rand_range(GAP_TIME[0], GAP_TIME[1]))
	pass

func _on_TimerEventGenerator_timeout():
	judge_events()
