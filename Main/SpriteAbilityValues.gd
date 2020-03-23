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
			$HBoxContainer.get_child(0).rect_scale = Vector2(1, 1)
			$HBoxContainer.move_child($HBoxContainer/PurpleValueBar, 0)
			yield(get_tree(), "idle_frame")
			$HBoxContainer/PurpleValueBar.rect_scale = Vector2(1.5, 1.5)
			pass
		Global.COLOR_TYPE.GREEN:
			$HBoxContainer.get_child(0).rect_scale = Vector2(1, 1)
			$HBoxContainer.move_child($HBoxContainer/GreenValueBar, 0)
			yield(get_tree(), "idle_frame")
			$HBoxContainer/GreenValueBar.rect_scale = Vector2(1.5, 1.5)
			pass
		Global.COLOR_TYPE.ORANGE:
			$HBoxContainer.get_child(0).rect_scale = Vector2(1, 1)
			$HBoxContainer.move_child($HBoxContainer/OrangeValueBar, 0)
			yield(get_tree(), "idle_frame")
			$HBoxContainer/OrangeValueBar.rect_scale = Vector2(1.5, 1.5)
			pass
		Global.COLOR_TYPE.RED:
			$HBoxContainer.get_child(0).rect_scale = Vector2(1, 1)
			$HBoxContainer.move_child($HBoxContainer/RedValueBar, 0)
			yield(get_tree(), "idle_frame")
			$HBoxContainer/RedValueBar.rect_scale = Vector2(1.5, 1.5)
			pass
		Global.COLOR_TYPE.BLUE:
			$HBoxContainer.get_child(0).rect_scale = Vector2(1, 1)
			$HBoxContainer.move_child($HBoxContainer/BlueValueBar, 0)
			yield(get_tree(), "idle_frame")
			$HBoxContainer/BlueValueBar.rect_scale = Vector2(1.5, 1.5)
			pass
		Global.COLOR_TYPE.YELLOW:
			$HBoxContainer.get_child(0).rect_scale = Vector2(1, 1)
			$HBoxContainer.move_child($HBoxContainer/YellowValueBar, 0)
			yield(get_tree(), "idle_frame")
			$HBoxContainer/YellowValueBar.rect_scale = Vector2(1.5, 1.5)
	pass
