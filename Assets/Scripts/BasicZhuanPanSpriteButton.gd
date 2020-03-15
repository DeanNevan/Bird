extends TextureButton

signal changed_sprite_type(new_type)

var is_pressed = false

var type

onready var Tween1 = Tween.new()
func _init():
	add_to_group("ZhuanPanSpriteButtons")

func _ready():
	$Light2D.enabled = false
	$Light2D.energy = 0
	$TextureProgress.value = 0
	add_child(Tween1)
	Global.connect_and_detect(connect("pressed", self, "_pressed"))
	Global.connect_and_detect(connect("button_down", self, "_on_button_down"))
	Global.connect_and_detect(connect("button_up", self, "_on_button_up"))
	Global.connect_and_detect(connect("mouse_entered", self, "_on_mouse_entered"))
	Global.connect_and_detect(connect("mouse_exited", self, "_on_mouse_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Light2D.energy == 0:
		$Light2D.enabled = false
	else:
		$Light2D.enabled = true
	#$Light2D.position = rect_position / 2
	#$Light2D.global_position = Vector2(900, 560)
	
	#if Sprites.player_sprites[type] == 0:
	#	visible = false
	#else:
	#	visible = true
	$Label.text = str(Sprites.player_sprites[type])
	pass

func _on_mouse_entered():
	Tween1.interpolate_property($TextureProgress, "value", $TextureProgress.value, 100, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	if !Tween1.is_active():
		Tween1.start()
	pass

func _on_mouse_exited():
	if is_pressed:
		return
	Tween1.interpolate_property($TextureProgress, "value", $TextureProgress.value, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	if !Tween1.is_active():
		Tween1.start()
	pass

func _pressed():
	for i in get_tree().get_nodes_in_group("ZhuanPanSpriteButtons"):
		if i != self:
			i.cancel_select()
	pass

func _on_button_down():
	select()
	pass

func _on_button_up():
	pressed = true
	pass

func select():
	is_pressed = true
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 1.2, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	emit_signal("changed_sprite_type", type)
	pass

func cancel_select():
	is_pressed = false
	_on_mouse_exited()
	#pressed = false
	Tween1.interpolate_property($Light2D, "energy", $Light2D.energy, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	pass
