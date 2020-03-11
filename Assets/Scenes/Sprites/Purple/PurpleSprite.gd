extends "res://Assets/Scripts/BasicSprite.gd"

signal body_visible(body)
signal body_invisible(body)

var view_radius = Global.SPRITE_BASIC_VIEW_RADIUS

#var visible_targets := []

var Player
func _init():
	add_to_group("Sprites")
# Called when the node enters the scene tree for the first time.
func _ready():
	$CircleViewArea.update_CollisionShape(view_radius)
	Global.connect_and_detect($CircleViewArea.connect("body_invisible", self, "_on_ViewArea_body_invisible"))
	Global.connect_and_detect($CircleViewArea.connect("body_visible", self, "_on_ViewArea_body_visible"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ViewArea_body_visible(body):
	#visible_targets.append(body)
	emit_signal("body_visible", body)
	pass

func _on_ViewArea_body_invisible(body):
	emit_signal("body_invisible", body)
	#visible_targets.erase(body)
	pass
