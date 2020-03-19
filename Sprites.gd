extends Node

signal added_new_sprite(sprite_type)
signal removed_sprite(sprite_type)

signal ability_value_changed(sprite_type, target_value)
signal changed_sprite(new_sprite)

var GREEN_SPRITE = preload("res://Assets/Scenes/Sprites/Green/GreenSprite.tscn")
var PURPLE_SPRITE = preload("res://Assets/Scenes/Sprites/Purple/PurpleSprite.tscn")



var player_sprites = {Global.COLOR_TYPE.PURPLE : 0, Global.COLOR_TYPE.GREEN : 0}

#主动能力的能力值
var sprites_ability_values := {Global.COLOR_TYPE.PURPLE : 0, Global.COLOR_TYPE.GREEN : 0}

var is_launching_ability = false

var now_type

var Player
var MainScene

var PURPLE_SE = preload("res://Assets/Scenes/Sprites/Purple/AbilitySEPurple.tscn")
var GREEN_SE = preload("res://Assets/Scenes/Sprites/Green/AbilitySEGreen.tscn")
onready var Draw = Node2D.new()
onready var PurpleAbilityValueTimer = Timer.new()
var purple_ability_value_time = 1
onready var GreenAbilityValueTimer = Timer.new()
var green_ability_value_time = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Draw)
	_init_ValueTimers()
	
	for i in get_tree().get_nodes_in_group("ZhuanPanSpriteButtons"):
		Global.connect_and_detect(i.connect("changed_sprite_type", self, "_on_changed_sprite_type"))
	pass # Replace with function body.


func _unhandled_input(event):
	if event.is_action_pressed("key_space"):
		launch_ability()
	if event.is_action_released("key_space"):
		stop_ability()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_new_sprite(target_type = 0):
	var new_target
	match target_type:
		Global.COLOR_TYPE.GREEN:
			new_target = GREEN_SPRITE.instance()
		Global.COLOR_TYPE.PURPLE:
			new_target = PURPLE_SPRITE.instance()
	new_target.Player = Player
	new_target.modulate = Color(1, 1, 1, 0)
	new_target.is_working = false
	add_child(new_target)
	player_sprites[target_type] += 1
	sprites_ability_values[target_type] += 1
	emit_signal("added_new_sprite", target_type)
	pass

func remove_sprite(sprite_type = 0):
	emit_signal("removed_sprite", sprite_type)
	pass

func _on_changed_sprite_type(new_type):
	if now_type == new_type:
		return
	for i in get_child_count():
		var object = get_child(i)
		if object.has_method("appear"):
			if object.color_type == new_type:
				object.appear()
			elif object.color_type == now_type:
				object.disappear()
	now_type = new_type
	#Player.modulate = Global.COLORS[now_type]
	emit_signal("changed_sprite", now_type)
	pass

func launch_ability():
	if now_type == null:
		return
	if sprites_ability_values[now_type] <= 0:
		return
	match now_type:
		Global.COLOR_TYPE.PURPLE:
			if sprites_ability_values[now_type] < 1:
				return
			change_ability_value(now_type, -1)
			var new_se = PURPLE_SE.instance()
			new_se.global_position = Draw.get_global_mouse_position()
			MainScene.add_child(new_se)
			new_se.start()
			yield(new_se, "finished")
			Player.global_position = new_se.global_position
			pass
		Global.COLOR_TYPE.GREEN:
			if sprites_ability_values[now_type] < 1:
				return
			change_ability_value(now_type, -1)
			var new_se = GREEN_SE.instance()
			new_se.global_position = Player.global_position
			MainScene.add_child(new_se)
			new_se.start()
			pass
	pass

func stop_ability():
	pass

func change_ability_value(sprite_type, delta):
	sprites_ability_values[sprite_type] = clamp(sprites_ability_values[sprite_type] + delta, 0, player_sprites[sprite_type])
	emit_signal("ability_value_changed", sprite_type, sprites_ability_values[sprite_type])

func _init_ValueTimers():
	add_child(PurpleAbilityValueTimer)
	PurpleAbilityValueTimer.one_shot = true
	PurpleAbilityValueTimer.start(purple_ability_value_time)
	Global.connect_and_detect(PurpleAbilityValueTimer.connect("timeout", self, "_on_PurpleAbilityValueTimer_time_out"))
	
	add_child(GreenAbilityValueTimer)
	GreenAbilityValueTimer.one_shot = true
	GreenAbilityValueTimer.start(green_ability_value_time)
	Global.connect_and_detect(GreenAbilityValueTimer.connect("timeout", self, "_on_GreenAbilityValueTimer_time_out"))

func _on_PurpleAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.PURPLE, 0.1)
	PurpleAbilityValueTimer.start(purple_ability_value_time)
func _on_GreenAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.GREEN, 0.1)
	GreenAbilityValueTimer.start(green_ability_value_time)
