extends Node

signal changed_sprite(new_sprite)

var GREEN_SPRITE = preload("res://Assets/Scenes/Sprites/Green/GreenSprite.tscn")
var PURPLE_SPRITE = preload("res://Assets/Scenes/Sprites/Purple/PurpleSprite.tscn")


var player_sprites = {Global.COLOR_TYPE.PURPLE : 0, Global.COLOR_TYPE.GREEN : 0}

var now_type

var Player


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("ZhuanPanSpriteButtons"):
		Global.connect_and_detect(i.connect("changed_sprite_type", self, "_on_changed_sprite_type"))
	pass # Replace with function body.


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
