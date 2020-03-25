extends RayCast2D

signal target_visible(target)
signal target_invisible(target)

var user
var target
var is_target_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null and is_instance_valid(target) and user != null and is_instance_valid(user):
		global_position = user.global_position
		cast_to = target.global_position - user.global_position
		clear_exceptions()
		add_exception(user)
		if is_colliding():
			while true:
				if !is_colliding():
					#print("1")
					break
				var object = get_collider()
				if !is_instance_valid(object):
					#print("2")
					break
				if object.type == Global.TYPE.WALL:
					if is_target_visible:
						emit_signal("target_invisible", target)
						is_target_visible = false
					#print("3")
					break
				elif object != target:
					#print("4")
					add_exception(object)
				else:
					if !is_target_visible:
						emit_signal("target_visible", target)
						is_target_visible = true
					#print("5")
					break
				force_raycast_update()
				
	else:
		#print("6")
		enabled = false
		queue_free()
