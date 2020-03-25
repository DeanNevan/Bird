extends Node

enum TYPE{
	PLAYER
	SPRITE
	ENEMY
	WALL
	COLLECTION
	ABILITY
}

enum COLOR_TYPE{
	WHITE
	PURPLE
	GREEN
	ORANGE
	RED
	BLUE
	YELLOW
}

var Player

var VELOCITY_BASIC_PARA = 35.0

var PLAYER_BASIC_SPEED = 20
var PLAYER_BASIC_MAX_SPEED = 1700
var PLAYER_BASIC_ROTATE_SPEED = 25
#var PLAYER_BASIC_MAX_ROTATE_SPEED = 10
var PLAYER_BASIC_VIEW_RADIUS = 330
var PLAYER_BASIC_VIEW_LENGTH = 3100
var PLAYER_BASIC_VIEW_WIDTH = 1200

var SPRITE_BASIC_VIEW_RADIUS = 230

var COLORS={COLOR_TYPE.WHITE : Color.white,
			COLOR_TYPE.PURPLE : Color.purple,
			COLOR_TYPE.GREEN : Color.green,
			COLOR_TYPE.ORANGE : Color.orange,
			COLOR_TYPE.RED : Color.red,
			COLOR_TYPE.BLUE : Color.blue,
			COLOR_TYPE.YELLOW : Color.yellow
			}

func connect_and_detect(return_value):
	if return_value != 0:
		print("wrong connection", return_value)
		return false
	return true
	pass
