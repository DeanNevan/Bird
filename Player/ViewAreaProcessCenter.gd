extends Node


var visible_targets_list := {}#{target:count}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_connection():
	if !get_parent().is_connected("body_visible", self, "_on_ViewArea_body_visible"):
		Global.connect_and_detect(get_parent().connect("body_visible", self, "_on_ViewArea_body_visible"))
	if !get_parent().is_connected("body_invisible", self, "_on_ViewArea_body_invisible"):
		Global.connect_and_detect(get_parent().connect("body_invisible", self, "_on_ViewArea_body_invisible"))
	for i in get_tree().get_nodes_in_group("Sprites"):
		if !i.is_connected("body_visible", self, "_on_ViewArea_body_visible"):
			Global.connect_and_detect(i.connect("body_visible", self, "_on_ViewArea_body_visible"))
		if !i.is_connected("body_invisible", self, "_on_ViewArea_body_invisible"):
			Global.connect_and_detect(i.connect("body_invisible", self, "_on_ViewArea_body_invisible"))
	

func _on_ViewArea_body_visible(body):
	if body == get_parent():
		return
	if body.has_method("visible_on_screen"):
		body.visible_on_screen()
	if visible_targets_list.has(body):
		visible_targets_list[body] += 1
	else:
		visible_targets_list[body] = 1 
	pass

func _on_ViewArea_body_invisible(body):
	if body == get_parent():
		return
	if visible_targets_list.has(body):
		visible_targets_list[body] -= 1
		if visible_targets_list[body] <= 0:
			visible_targets_list.erase(body)
			if body.has_method("invisible_on_screen"):
				body.invisible_on_screen()
	pass
