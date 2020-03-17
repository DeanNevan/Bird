extends Node2D

var LENGTH = 1400.0

var WIDTH = 160.0

func _ready():
	#test()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_shape(length, width):
	scale.x = float(length) / LENGTH
	scale.y = float(width) / WIDTH
	pass

func update_light_sprite(is_enabled = true, light_energy = 1, sprite_alpha = 0.005, light_scale = 1):
	$Light2D.enabled = true
	$Light2D.energy = light_energy
	$Sprite.modulate = Color($Sprite.modulate.r, $Sprite.modulate.g, $Sprite.modulate.b, sprite_alpha)
	$Light2D.texture_scale = light_scale
	

func test():
	while true:
		yield(get_tree().create_timer(1), "timeout")
		$Light2D.energy += 0.3
