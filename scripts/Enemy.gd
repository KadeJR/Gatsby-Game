extends Sprite2D

@export var characterName: String

@export var health: int

enum Moves {
	MONEY_STORM = 0,
	RIZZ = 1,
	GREEN_LIGHT = 2,
	YELL = 3,
	ATTRACT = 4,
	GUN = 5,
	GOLD_STORM = 6,
	MONEY_STORM_ENEMY = 7,
	RIZZ_ENEMY = 8,
	GREEN_LIGHT_ENEMY = 9,
	NONE = 100
}

@export var move1 = Moves.NONE
@export var move2 = Moves.NONE
@export var move3 = Moves.NONE

enum Backgrounds {
	GATSBY_HOUSE = 0,
	BUCHANNAN_HOUSE = 1,
	CITY = 2,
	POOL = 3,
}

@export var background: Backgrounds

enum Music {
	CITY = 0,
	DAISY = 1,
	EVOLVE = 2,
	MYRTLE_POOL = 3,
	NICK_TOM = 4,
	WILSON = 5
}

@export var music: Music

@export var weakness: Moves

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
