extends RayCast2D

signal target_visible(target)
signal target_invisible(target)

var target
var is_target_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null and is_instance_valid(target):
		if get_collider() != null and is_instance_valid(get_collider()):
			if is_target_visible:
				if get_collider().type == Global.TYPE.WALL:
					emit_signal("target_invisible", target)
					is_target_visible = false
			else:
				if get_collider().type != Global.TYPE.WALL:
					emit_signal("target_visible", target)
					is_target_visible = true
		cast_to = target.global_position - get_parent().global_position
	else:
		queue_free()
