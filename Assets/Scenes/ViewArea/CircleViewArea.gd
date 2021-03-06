extends Area2D

signal body_visible(body)
signal body_invisible(body)

var user

var is_perspective = false#是否透视

var targets = []#视野范围内的目标
var visible_targets = []#视野范围内可见的目标

var ViewRay = preload("res://Assets/Scenes/ViewArea/ViewRay.tscn")
var view_rays = {}#{target:ray}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_CollisionShape(radius):
	$CollisionShape2D.shape.radius = radius
	pass

func update_signal_connection():
	if user != null and is_instance_valid(user):
		Global.connect_and_detect(connect("body_invisible", user, "_on_ViewArea_body_invisible"))
		Global.connect_and_detect(connect("body_visible", user, "_on_ViewArea_body_visible"))
	pass

func _on_ViewArea_body_entered(body):
	if body != user and body.type != Global.TYPE.WALL:
		if is_perspective:
			if !targets.has(body):
				targets.append(body)
			if !visible_targets.has(body):
				visible_targets.append(body)
				emit_signal("body_visible", body)
		else:
			if !targets.has(body):
				targets.append(body)
				var newViewRay = ViewRay.instance()
				newViewRay.target = body
				newViewRay.connect("target_visible", self, "_on_ViewRay_target_visible")
				newViewRay.connect("target_invisible", self, "_on_ViewRay_target_invisible")
				newViewRay.user = user
				Global.add_child(newViewRay)
				view_rays[body] = newViewRay
		
	pass # Replace with function body.

func _on_ViewArea_body_exited(body):
	targets.erase(body)
	if visible_targets.has(body):
		visible_targets.erase(body)
	if is_instance_valid(body) and view_rays.has(body):
		if is_instance_valid(view_rays[body]):
			if view_rays[body].has_method("queue_free"):
				view_rays[body].queue_free()
	emit_signal("body_invisible", body)
	view_rays.erase(body)
	pass # Replace with function body.

func _on_ViewRay_target_visible(_target):
	if targets.has(_target) and !visible_targets.has(_target):
		emit_signal("body_visible", _target)
		visible_targets.append(_target)
	pass

func _on_ViewRay_target_invisible(_target):
	if visible_targets.has(_target):
		emit_signal("body_invisible", _target)
		visible_targets.erase(_target)
	pass
