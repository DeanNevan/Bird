extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var Player = preload("res://Player/Player.tscn").instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	Sprites.MainScene = self
	#add_child(Player)
	Sprites.Player = $Player
	Global.Player = $Player
	Sprites.add_new_sprite(Global.COLOR_TYPE.PURPLE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.PURPLE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.PURPLE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.PURPLE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.GREEN)
	Sprites.add_new_sprite(Global.COLOR_TYPE.GREEN)
	Sprites.add_new_sprite(Global.COLOR_TYPE.GREEN)
	Sprites.add_new_sprite(Global.COLOR_TYPE.ORANGE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.ORANGE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.ORANGE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.ORANGE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.RED)
	Sprites.add_new_sprite(Global.COLOR_TYPE.RED)
	Sprites.add_new_sprite(Global.COLOR_TYPE.RED)
	Sprites.add_new_sprite(Global.COLOR_TYPE.RED)
	Sprites.add_new_sprite(Global.COLOR_TYPE.RED)
	Sprites.add_new_sprite(Global.COLOR_TYPE.BLUE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.BLUE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.BLUE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.BLUE)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	Sprites.add_new_sprite(Global.COLOR_TYPE.YELLOW)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delta != 0:
		var fps = ceil(1 / delta)
		$GUI/Label.text = "FPS:" + str(fps)
		if fps <= 50:
			$GUI/Label.modulate = Color.yellow
			if fps <= 40:
				$GUI/Label.modulate = Color.red
		else:
			$GUI/Label.modulate = Color.white
