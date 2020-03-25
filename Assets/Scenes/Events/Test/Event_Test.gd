extends Node2D

signal event_ended

onready var event_range = $EventArea/CollisionShape2D.shape.extents.length()

func _ready():
	Global.connect_and_detect($EventArea.connect("body_exited", self, "_on_body_exited"))
	for i in $Enemies.get_children():
		i.Nav = $Navigation2D
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_body_exited(body):
	if is_instance_valid(body):
		if body.type == Global.TYPE.PLAYER:
			emit_signal("event_ended")
			queue_free()
