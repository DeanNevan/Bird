extends Node2D

var color = Color.white

var width = 12
#var residence_time = 2

var is_drawing = false
var is_connect_done = false

var points_array := []
var left_points_array := []
var colors_array := []

func _ready():
	pass
	

func _draw():
	if points_array.size() >= 2:
		colors_array = []
		for i in points_array.size():
			colors_array.append(Color(color.r, 
									  color.g,
									  color.b,
									  1 * float(i) / float(points_array.size()))
								)
		draw_polyline_colors(points_array, colors_array, width, true)
	for a in left_points_array.size():
		if left_points_array[a].size() < 2:
			continue
		colors_array = []
		for i in left_points_array[a].size():
			colors_array.append(Color(color.r, 
								  color.g,
								  color.b,
								  1 * float(i) / float(left_points_array[a].size()))
								)
		draw_polyline_colors(left_points_array[a], colors_array, width, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	for a in left_points_array:
		a.pop_front()
		if a.size() < 2:
			left_points_array.erase(a)
	if !is_drawing:
		if points_array.size() > 0:
			left_points_array.append(points_array.duplicate())
			points_array.clear()
		

func _on_draw():
	is_drawing = true

func _on_not_draw():
	is_drawing = false
