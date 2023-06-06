extends ColorRect

var maxSize = 360
var sizeX
@export var percentPerSecLost = 0.7
@export var maxHealth: int
@export var health: int

# Called when the node enters the scene tree for the first time.
func _ready():
	sizeX = (health / maxHealth * maxSize) as int
	health = maxHealth
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	
	if (health > maxHealth):
		health = maxHealth
	if (health < 0):
		health= 0
	
	# life bar size with given health
	sizeX = (health as float / maxHealth as float) * maxSize as float
	
	# smooth health bar
	self.size.x -= percentPerSecLost * 360 * delta
	if (self.size.x <= sizeX):
		self.size.x = sizeX
	
	# colored health bar
	if (self.size.x / maxSize <= 1):
		self.color = Color8(71, 138, 71, 255)
	if (self.size.x/360 <= 0.5):
		self.color = Color8(255, 200, 0, 255)
	if (self.size.x/360 <= 0.2):
		self.color = Color8(255, 0, 0, 255)
	if (self.size.x <= 0):
		size.x = 0
		
	pass
