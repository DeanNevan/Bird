extends Control

var is_disappearing = false

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgress.value = 0
	$TextureProgress/CircularContainer.set_percent_visible(0)
	add_child(Tween1)
	disappear()
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("key_tab"):
		appear()
	if event.is_action_released("key_tab"):
		disappear()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("key_tab"):
		appear()
	if Input.is_action_just_released("key_tab"):
		disappear()
	if visible:
		if Input.is_action_just_released("wheel_up"):
			if !Tween1.is_active():
				Tween1.interpolate_method($TextureProgress/CircularContainer, "set_start_angle_deg", $TextureProgress/CircularContainer.get_start_angle_deg(), $TextureProgress/CircularContainer.get_start_angle_deg() + 360 / $TextureProgress/CircularContainer.get_child_count(), 0.33, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				Tween1.start()
		if Input.is_action_just_released("wheel_down"):
			if !Tween1.is_active():
				Tween1.interpolate_method($TextureProgress/CircularContainer, "set_start_angle_deg", $TextureProgress/CircularContainer.get_start_angle_deg(), $TextureProgress/CircularContainer.get_start_angle_deg() - 360 / $TextureProgress/CircularContainer.get_child_count(), 0.33, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				Tween1.start()
	pass

func appear():
	visible = true
	is_disappearing = false
	Tween1.stop_all()
	var change_time = 0.4 * (100 - $TextureProgress.value) / 100
	Tween1.interpolate_property($TextureProgress, "value", $TextureProgress.value, 100, change_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_method($TextureProgress/CircularContainer, "set_percent_visible", $TextureProgress/CircularContainer.get_percent_visible(), 1, change_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	pass

func disappear():
	is_disappearing = true
	Tween1.stop_all()
	Tween1.interpolate_property($TextureProgress, "value", $TextureProgress.value, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_method($TextureProgress/CircularContainer, "set_percent_visible", $TextureProgress/CircularContainer.get_percent_visible(), 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	yield(Tween1, "tween_completed")
	if is_disappearing:
		visible = false
	pass
