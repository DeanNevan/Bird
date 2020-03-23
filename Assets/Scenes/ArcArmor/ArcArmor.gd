extends RigidBody2D

var armor_value = 50

var type = Global.TYPE.ABILITY

var user

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	armor_value = $TextureProgress.value
	update_shape(armor_value)
	pass

func change_value(new_value = 50, tween_time = 0.4):
	smooth_change_progress_value(new_value, tween_time)

func smooth_change_progress_value(target_value = 50, change_time = 0.4):
	$Tween.interpolate_property($TextureProgress, "value", $TextureProgress.value, target_value, change_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	pass

func update_shape(new_value):
	if new_value <= 35:
		$CollisionShape2D.disabled = true
		$CollisionShape2D7.disabled = true
		if new_value <= 22:
			$CollisionShape2D2.disabled = true
			$CollisionShape2D6.disabled = true
			if new_value <= 9:
				$CollisionShape2D3.disabled = true
				$CollisionShape2D5.disabled = true
				if new_value <= 0:
					$CollisionShape2D4.disabled = true
				else:
					$CollisionShape2D4.disabled = false
			else:
				$CollisionShape2D3.disabled = false
				$CollisionShape2D4.disabled = false
				$CollisionShape2D5.disabled = false
		else:
			$CollisionShape2D2.disabled = false
			$CollisionShape2D3.disabled = false
			$CollisionShape2D4.disabled = false
			$CollisionShape2D5.disabled = false
			$CollisionShape2D6.disabled = false
	else:
		$CollisionShape2D.disabled = false
		$CollisionShape2D2.disabled = false
		$CollisionShape2D3.disabled = false
		$CollisionShape2D4.disabled = false
		$CollisionShape2D5.disabled = false
		$CollisionShape2D6.disabled = false
		$CollisionShape2D7.disabled = false
