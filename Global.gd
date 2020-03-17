extends Node

enum TYPE{
	PLAYER
	SPRITE
	ENEMY
	WALL
	COLLECTION
}

enum COLOR_TYPE{
	PURPLE
	GREEN
}

var Player

var PLAYER_BASIC_SPEED = 20
var PLAYER_BASIC_MAX_SPEED = 1700
var PLAYER_BASIC_ROTATE_SPEED = 25
#var PLAYER_BASIC_MAX_ROTATE_SPEED = 10
var PLAYER_BASIC_VIEW_RADIUS = 300
var PLAYER_BASIC_VIEW_LENGTH = 2500
var PLAYER_BASIC_VIEW_WIDTH = 900

var SPRITE_BASIC_VIEW_RADIUS = 230

var COLORS={COLOR_TYPE.PURPLE : Color.purple,
			COLOR_TYPE.GREEN : Color.green
			}

func connect_and_detect(return_value):
	if return_value != 0:
		print("wrong connection", return_value)
		return false
	return true
	pass
