extends RigidBody2D


var type = Global.TYPE.ABILITY

var Player = Sprites.Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Player.global_position
	pass
