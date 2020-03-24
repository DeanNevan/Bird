extends Node

signal added_new_sprite(sprite_type)
signal removed_sprite(sprite_type)

signal ability_value_changed(sprite_type, target_value)
signal changed_sprite(new_sprite)

var GREEN_SPRITE = preload("res://Assets/Scenes/Sprites/Green/GreenSprite.tscn")
var PURPLE_SPRITE = preload("res://Assets/Scenes/Sprites/Purple/PurpleSprite.tscn")
var ORANGE_SPRITE = preload("res://Assets/Scenes/Sprites/Orange/OrangleSprite.tscn")
var RED_SPRITE = preload("res://Assets/Scenes/Sprites/Red/RedSprite.tscn")
var BLUE_SPRITE = preload("res://Assets/Scenes/Sprites/Blue/BlueSprite.tscn")
var YELLOW_SPRITE = preload("res://Assets/Scenes/Sprites/Yellow/YellowSprite.tscn")

var player_sprites := { Global.COLOR_TYPE.PURPLE : 0,
						Global.COLOR_TYPE.GREEN : 0,
						Global.COLOR_TYPE.ORANGE : 0,
						Global.COLOR_TYPE.RED : 0,
						Global.COLOR_TYPE.BLUE : 0,
						Global.COLOR_TYPE.YELLOW : 0
						}

#主动能力的能力值
var sprites_ability_values := { Global.COLOR_TYPE.PURPLE : 0,
								Global.COLOR_TYPE.GREEN : 0,
								Global.COLOR_TYPE.ORANGE : 0,
								Global.COLOR_TYPE.RED : 0,
								Global.COLOR_TYPE.BLUE : 0,
								Global.COLOR_TYPE.YELLOW : 0
								}

var is_launching_ability = false

var now_type

var Player
var MainScene

var PURPLE_SE = preload("res://Assets/Scenes/Sprites/Purple/AbilitySEPurple.tscn")
var GREEN_SE = preload("res://Assets/Scenes/Sprites/Green/AbilitySEGreen.tscn")
var ORANGE_SE = preload("res://Assets/Scenes/Sprites/Orange/AbilitySEOrange.tscn")
var RED_SE = preload("res://Assets/Scenes/Sprites/Red/AbilitySERed.tscn")
var BLUE_SE = preload("res://Assets/Scenes/Sprites/Blue/AbilitySEBlue.tscn")
var YELLOW_SE = preload("res://Assets/Scenes/Sprites/Yellow/AbiitySEYellow.tscn")

onready var Draw = Node2D.new()
onready var PurpleAbilityValueTimer = Timer.new()
var purple_ability_value_time = 1
onready var GreenAbilityValueTimer = Timer.new()
var green_ability_value_time = 0.5
onready var OrangeAbilityValueTimer = Timer.new()
var orange_ability_value_time = 0.8
onready var RedAbilityValueTimer = Timer.new()
var red_ability_value_time = 1.5
onready var BlueAbilityValueTimer = Timer.new()
var blue_ability_value_time = 1.2
onready var YellowAbilityValueTimer = Timer.new()
var yellow_ability_value_time = 1.3
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
		Global.COLOR_TYPE.ORANGE:
			new_target = ORANGE_SPRITE.instance()
		Global.COLOR_TYPE.RED:
			new_target = RED_SPRITE.instance()
		Global.COLOR_TYPE.BLUE:
			new_target = BLUE_SPRITE.instance()
		Global.COLOR_TYPE.YELLOW:
			new_target = YELLOW_SPRITE.instance()
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
		yield(get_tree(), "idle_frame")
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
		Global.COLOR_TYPE.ORANGE:
			if sprites_ability_values[now_type] < 1:
				return
			change_ability_value(now_type, -1)
			var new_se = ORANGE_SE.instance()
			new_se.global_position = Player.global_position
			Global.connect_and_detect(new_se.connect("dodged", self, "_on_OrangeAbility_dodged"))
			Global.connect_and_detect(new_se.connect("damaged", self, "_on_OrangeAbility_damaged"))
			MainScene.add_child(new_se)
			new_se.start()
		Global.COLOR_TYPE.RED:
			if sprites_ability_values[now_type] < 1:
				return
			change_ability_value(now_type, -1)
			var new_se = RED_SE.instance()
			new_se.global_position = Player.global_position
			Global.connect_and_detect(new_se.connect("damaged", self, "_on_RedAbility_damaged"))
			MainScene.add_child(new_se)
			new_se.start()
		Global.COLOR_TYPE.BLUE:
			if sprites_ability_values[now_type] < 1:
				return
			change_ability_value(now_type, -1)
			var new_se = BLUE_SE.instance()
			new_se.global_position = MainScene.get_global_mouse_position()
			MainScene.add_child(new_se)
			new_se.start()
		Global.COLOR_TYPE.YELLOW:
			if sprites_ability_values[now_type] < 1:
				return
			change_ability_value(now_type, -1)
			var new_se = YELLOW_SE.instance()
			new_se.global_position = Player.global_position
			Global.connect_and_detect(new_se.connect("perfect_defended", self, "_on_YellowAbility_perfect_defended"))
			MainScene.add_child(new_se)
			new_se.start()
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
	
	add_child(OrangeAbilityValueTimer)
	OrangeAbilityValueTimer.one_shot = true
	OrangeAbilityValueTimer.start(orange_ability_value_time)
	Global.connect_and_detect(OrangeAbilityValueTimer.connect("timeout", self, "_on_OrangeAbilityValueTimer_time_out"))
	
	add_child(RedAbilityValueTimer)
	RedAbilityValueTimer.one_shot = true
	RedAbilityValueTimer.start(red_ability_value_time)
	Global.connect_and_detect(RedAbilityValueTimer.connect("timeout", self, "_on_RedAbilityValueTimer_time_out"))
	
	add_child(BlueAbilityValueTimer)
	BlueAbilityValueTimer.one_shot = true
	BlueAbilityValueTimer.start(blue_ability_value_time)
	Global.connect_and_detect(BlueAbilityValueTimer.connect("timeout", self, "_on_BlueAbilityValueTimer_time_out"))
	
	add_child(YellowAbilityValueTimer)
	YellowAbilityValueTimer.one_shot = true
	YellowAbilityValueTimer.start(yellow_ability_value_time)
	Global.connect_and_detect(YellowAbilityValueTimer.connect("timeout", self, "_on_YellowAbilityValueTimer_time_out"))

func _on_PurpleAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.PURPLE, 0.1)
	PurpleAbilityValueTimer.start(purple_ability_value_time)
func _on_GreenAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.GREEN, 0.1)
	GreenAbilityValueTimer.start(green_ability_value_time)
func _on_OrangeAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.ORANGE, 0.1)
	OrangeAbilityValueTimer.start(orange_ability_value_time)
func _on_RedAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.RED, 0.1)
	RedAbilityValueTimer.start(red_ability_value_time)
func _on_BlueAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.BLUE, 0.1)
	BlueAbilityValueTimer.start(blue_ability_value_time)
func _on_YellowAbilityValueTimer_time_out():
	change_ability_value(Global.COLOR_TYPE.YELLOW, 0.1)
	YellowAbilityValueTimer.start(yellow_ability_value_time)

func _on_OrangeAbility_dodged():
	change_ability_value(Global.COLOR_TYPE.ORANGE, 0.5)
	pass
func _on_OrangeAbility_damaged():
	change_ability_value(Global.COLOR_TYPE.ORANGE, 0.2)

func _on_RedAbility_damaged(body):
	change_ability_value(Global.COLOR_TYPE.RED, 0.3)
	pass

func _on_YellowAbility_perfect_defended(body):
	change_ability_value(Global.COLOR_TYPE.YELLOW, 1)
	pass
