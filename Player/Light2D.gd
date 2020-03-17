extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var TweenLight = Tween.new()
func _ready():
	add_child(TweenLight)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if energy == 0:
		enabled = false
	else:
		enabled = true
	#print(enabled)
	#print(energy)

func smooth_change_light_energy(target_energy = 1, change_time = 0.5):
	TweenLight.interpolate_property(self, "energy", energy, target_energy, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if !TweenLight.is_active():
		TweenLight.start()

func smooth_change_light_color(target_color = Color.white, change_time = 0.5):
	TweenLight.interpolate_property(self, "color", color, target_color, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if !TweenLight.is_active():
		TweenLight.start()
