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

func update_CollisionShape(radius, length, width):
	$CollisionShape2D3.shape.radius = radius
	$CollisionShape2D.shape.points[1] = Vector2(length, -width)
	$CollisionShape2D.shape.points[2] = Vector2(length, width)
	$CollisionShape2D2.shape.points[0] = Vector2(length, -width)
	$CollisionShape2D2.shape.points[2] = Vector2(length, width)
	$CollisionShape2D2.shape.points[1] = Vector2(sqrt(length * length + width * width), 0)
	pass

func _on_ViewArea_body_entered(body):
	if body != user and body.type != Global.TYPE.WALL:
		if is_perspective:
			if !targets.has(body):
				targets.append(body)
			if !visible_targets.has(body):
				visible_targets.append(body)
		else:
			if !targets.has(body):
				targets.append(body)
				var newViewRay = ViewRay.instance()
				newViewRay.target = body
				newViewRay.connect("target_visible", self, "_on_ViewRay_target_visible")
				newViewRay.connect("target_invisible", self, "_on_ViewRay_target_invisible")
				add_child(newViewRay)
				view_rays[body] = newViewRay
		
	pass # Replace with function body.

func _on_ViewArea_body_exited(body):
	targets.erase(body)
	if visible_targets.has(body):
		visible_targets.erase(body)
	if is_instance_valid(body) and view_rays.has(body):
		view_rays[body].queue_free()
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
