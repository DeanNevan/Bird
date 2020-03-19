extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect_and_detect(Sprites.connect("changed_sprite", self, "_on_changed_sprite"))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_changed_sprite(new_type):
	match new_type:
		Global.COLOR_TYPE.PURPLE:
			$HBoxContainer.move_child($HBoxContainer/PurpleValueBar, 0)
			pass
		Global.COLOR_TYPE.GREEN:
			$HBoxContainer.move_child($HBoxContainer/GreenValueBar, 0)
			pass
	pass
