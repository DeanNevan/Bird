extends Node


var visible_targets_list := {}#{target:count}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
			


func _on_ViewArea_body_visible():
	
	pass

func _on_ViewArea_body_invisible():
	pass
