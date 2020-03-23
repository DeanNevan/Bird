extends Camera2D

var min_zoom = 1.5
var max_zoom = 4.5

onready var TweenPlayer = Tween.new()
func _ready():
	add_child(TweenPlayer)
	#Global.connect_and_detect(Global.Player.connect("cancelled_control", self, "_on_Player_cancelled_control"))
	#Global.connect_and_detect(Global.Player.connect("controlled", self, "_on_Player_controlled"))
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_released("wheel_up"):
		zoom_up()
	elif event.is_action_released("wheel_down"):
		zoom_down()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.Player.is_controlling:
		global_position = (Global.Player.global_position / 2 + get_global_mouse_position() / 2)
		pass
	else:
		global_position = Global.Player.global_position

func zoom_up(delta_zoom = 0.3):
	var _zoom = clamp(zoom.x - delta_zoom, min_zoom, max_zoom)
	smooth_zoom(Vector2(_zoom, _zoom))

func zoom_down(delta_zoom = 0.3):
	var _zoom = clamp(zoom.x + delta_zoom, min_zoom, max_zoom)
	smooth_zoom(Vector2(_zoom, _zoom))

func smooth_zoom(target_zoom, speed = 0.25):
	#TweenPlayer.stop_all()
	TweenPlayer.interpolate_property(self, "zoom", zoom, target_zoom, speed, Tween.TRANS_CIRC, Tween.EASE_OUT)
	TweenPlayer.start()

func _on_Player_cancelled_control():
	TweenPlayer.stop_all()
	TweenPlayer.interpolate_property(self, "zoom", zoom, Vector2(2.1, 2.1), 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenPlayer.start()
	pass

func _on_Player_controlled():
	TweenPlayer.stop_all()
	TweenPlayer.interpolate_property(self, "zoom", zoom, Vector2(3.8, 3.8), 0.35, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenPlayer.start()
	pass
