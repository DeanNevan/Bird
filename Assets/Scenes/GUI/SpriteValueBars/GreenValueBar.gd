extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var TweenValue = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(TweenValue)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func smooth_change_value(target_value = value + 0.1, change_time = 0.3):
	TweenValue.interpolate_property(self, "value", value, target_value, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenValue.start()
	$Number.text = str(floor(target_value))
