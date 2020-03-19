extends TextureProgress


var sprite_type = Global.COLOR_TYPE.PURPLE

onready var TweenValue = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect_and_detect(Sprites.connect("ability_value_changed", self, "_on_ability_value_changed"))
	#Global.connect_and_detect(Sprites.connect("removed_sprite", self, "_on_removed_sprite"))
	#Global.connect_and_detect(Sprites.connect("added_new_sprite", self, "_on_added_new_sprite"))
	$Number.text = str(Sprites.sprites_ability_values[sprite_type])
	add_child(TweenValue)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func smooth_change_value(target_value = value + 0.1, change_time = 0.3):
	TweenValue.interpolate_property(self, "value", value, target_value, change_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenValue.start()

func _on_ability_value_changed(type, new_value):
	if type == sprite_type:
		if new_value == Sprites.player_sprites[type]:
			smooth_change_value(1, 0.3)
		else:
			smooth_change_value(new_value - floor(new_value), 0.3)
		$Number.text = str(floor(new_value))
	pass

func _on_added_new_sprite(target_type):
	pass

func _on_removed_sprite(target_type):
	pass
