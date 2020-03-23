extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_animation()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_animation():
	$AnimationPlayer.play("1")
	$AnimatedSprite.flip_h = false
	yield($AnimationPlayer, "animation_finished")
	$AnimatedSprite.play("2")
	$AnimatedSprite.flip_v = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("1")
	yield($AnimatedSprite, "animation_finished")
	$AnimationPlayer.play("2")
	$AnimatedSprite.flip_h = true
	yield($AnimationPlayer, "animation_finished")
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.play("2")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("1")
	yield($AnimatedSprite, "animation_finished")
	#yield(get_tree().create_timer(0.2), "timeout")
	play_animation()
