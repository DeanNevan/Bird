extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$EventsLabel.visible = false
	add_child(Tween1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func display(event : Node2D):
	$EventsLabel.visible = true
	$EventsLabel/Name.text = event.name_CN
	$EventsLabel/Infomation.text = event.infomation
	Tween1.interpolate_property($EventsLabel, "modulate", Color(event.color.r, event.color.g, event.color.b, 0), Color(event.color.r, event.color.g, event.color.b, 1), 0.9, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($EventsLabel/Name.get_font("font"), "extra_spacing_char", 0, 30, 1.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.interpolate_property($EventsLabel/Infomation, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	yield(get_tree().create_timer(2.5), "timeout")
	Tween1.interpolate_property($EventsLabel, "modulate", Color(event.color.r, event.color.g, event.color.b, 1), Color(event.color.r, event.color.g, event.color.b, 0), 0.9, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.interpolate_property($EventsLabel/Infomation, "percent_visible", 1, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	yield(Tween1, "tween_all_completed")
	print("hahahahaha")
	$EventsLabel/Name.get_font("font").extra_spacing_char = 0
	pass
