extends "res://Assets/Scripts/BasicEvent.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init():
	name_CN = "测试场景"
	infomation = "这是一个用于测试的场景"
	generation_value = 1
	event_range = Vector2(5624, 4216).length()
	Scene = preload("res://Assets/Scenes/Events/Test/Event_Test.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	type = Events.TYPE.TEST
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
