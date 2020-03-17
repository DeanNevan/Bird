extends RayCast2D

signal target_visible(target)
signal target_invisible(target)

var user
var target
var is_target_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null and is_instance_valid(target) and user != null and is_instance_valid(user):
		global_position = user.global_position
		cast_to = target.global_position - user.global_position
		if is_colliding():
			if is_target_visible:
				emit_signal("target_invisible", target)
				is_target_visible = false
		else:
			if !is_target_visible:
				emit_signal("target_visible", target)
				is_target_visible = true
	else:
		queue_free()
