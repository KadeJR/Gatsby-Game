extends Sprite2D

@export var characterName: String

enum Moves {
	MONEY_STORM = 0,
	RIZZ = 1,
	GREEN_LIGHT = 2,
	YELL = 3,
	ATTRACT = 4,
	GUN = 5,
	GOLD_STORM = 6,
	NONE
}

@export var move1 = Moves.NONE
@export var move2 = Moves.NONE
@export var move3 = Moves.NONE

@export var weakness: Moves

var timeSinceLastBounce
const ORIGINAL_Y = 850
const NAME = "Jay Gatsby"

var bouncing: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	timeSinceLastBounce = 0
	pass # Replace with function body.

func bounce(delta):
	timeSinceLastBounce += delta
	
	if (timeSinceLastBounce <= 0.2):
		self.global_position.y = (ORIGINAL_Y - 20)
	elif (timeSinceLastBounce <= 0.4):
		self.global_position.y = ORIGINAL_Y
	else:
		timeSinceLastBounce = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (bouncing):
		bounce(delta)
	else:
		timeSinceLastBounce = 0
		self.global_position.y = ORIGINAL_Y
	pass
