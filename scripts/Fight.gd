extends Node2D

var timer

var currentState: GameState

enum GameState {
	CHOOSE_ATTACK,
	PLAYER_ATTACK,
	ENEMY_ATTACK,
	WIN,
	LOSE,
}

@export var currentBackDrop: BackDrops

enum BackDrops {
	GATSBY_HOUSE = 0,
	BUCHANAN_HOUSE = 1,
	CITY = 2,
}

@export var currentEnemy: Enemies
var currentEnemyName: String
var enemyHealth: int
var enemyMove1
var enemyMove2
var enemyMove3
var chosenEnemyAttack

enum Enemies {
	PLACEHOLDER = 0,
	NICK = 1,
	DAISY = 2,
	TOM_1 = 3,
	Tom_2 = 4,
	Wilson = 5
}

var playerHealth: int
var attacks: Node2D
var chosenAttack: Attacks

enum Attacks {
	NONE = 100,
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
}

var assets: Node2D

enum Assets {
	ENEMIES = 0,
	PLAYER_SPRITE = 1
}

var UI: Control

var startEmitting
var jsonFile: FileAccess
var jsonString
var jsonData

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0 
	
	attacks = get_child(0)
	
	assets = get_child(1)
	
	UI = get_child(2)
	
	startEmitting = false
	
	enemyChanged = true
	
	jsonFile = FileAccess.open("user://save.json", FileAccess.READ_WRITE)
	
	jsonString = jsonFile.get_as_text()
	jsonData = {}
	jsonData = JSON.parse_string(jsonString)
	
	currentEnemy = jsonData["currentEnemy"]
	jsonData["currentEnemy"] += 1
	
	chooseAttackinit()
	
	pass # Replace with function body.

func getAttack(attack: Attacks):
	return attacks.get_child(attack)
	
func getAsset(asset: Assets):
	return assets.get_child(asset)
	
func setTextBox(text: String):
	UI.get_child(3).get_child(0).textCont = text
	
func textBoxVisible(isVisible):
	UI.get_child(3).visible = isVisible
	
func buttonsVisible(isVisible):
	UI.get_child(0).visible = isVisible
	
func chooseAttackinit():
	currentState = GameState.CHOOSE_ATTACK
	chosenAttack = Attacks.NONE
	UI.get_child(0).button_pressed = false
	
	assets.get_child(Assets.PLAYER_SPRITE).bouncing = true
	
	textBoxVisible(false)
	buttonsVisible(true)
		
func playerAttackInit(attack: Attacks):
	timer = 0
	playedEffect = false
	currentState = GameState.PLAYER_ATTACK
	chosenAttack = attack
	enemyHealth = UI.get_child(2).get_child(1).health - getAttack(chosenAttack).damage
	buttonsVisible(false)
	setTextBox(("Jay Gatsby used " + attacks.get_child(chosenAttack).attackName as String + "..."))
	assets.get_child(Assets.PLAYER_SPRITE).bouncing = false
	textBoxVisible(true)
	getAttack(chosenAttack).emitting = true
	
	
var playedEffect
func playerAttack(delta):	
	
	if (getAttack(chosenAttack).emitting == false):
		timer += delta
		if (timer >= getAttack(chosenAttack).lifetime):
			if (enemyHealth <= 0):
				winInit()
			else:
				enemyAttackInit()
		elif (timer >= 0.2):
			if (not playedEffect):
				assets.get_child(4).get_child(0).playing = true
				playedEffect = true
			getAsset(Assets.ENEMIES).visible = true
			UI.get_child(2).get_child(1).health = enemyHealth
		elif (timer >= 0):
			getAsset(Assets.ENEMIES).visible = false

		
func enemyAttackInit():
	currentState = GameState.ENEMY_ATTACK
	timer = 0
	
	playedEffect = false
	
	enemyMove1 = assets.get_child(0).get_child(currentEnemy).move1
	enemyMove2 = assets.get_child(0).get_child(currentEnemy).move2
	enemyMove3 = assets.get_child(0).get_child(currentEnemy).move3
	var loop = true
	var randChoice
	var validAttacks = 0
	if (not (enemyMove1 == 100)):
		validAttacks += 1
	if (not (enemyMove2 == 100)):
		validAttacks += 1
	if (not (enemyMove3 == 100)):
		validAttacks += 1
	
	randChoice = randi() % validAttacks + 1
	if (randChoice == 1):
		chosenEnemyAttack = enemyMove1
	elif (randChoice == 2):
		chosenEnemyAttack = enemyMove2
	elif (randChoice == 3):
		chosenEnemyAttack = enemyMove3
		
	playerHealth = UI.get_child(1).get_child(1).health - getAttack(chosenEnemyAttack).damage
	setTextBox((currentEnemyName + " used " + attacks.get_child(chosenEnemyAttack).attackName as String + "..."))
		
	getAttack(chosenEnemyAttack).emitting = true
	return 0

func enemyAttack(delta):
	if (getAttack(chosenEnemyAttack).emitting == false):
		timer += delta
		if (timer >= getAttack(chosenEnemyAttack).lifetime):
			if (playerHealth <= 0):
				loseInit()
			else:
				currentState = GameState.CHOOSE_ATTACK
				chooseAttackinit()
		elif (timer >= 0.2):
			if (not playedEffect):
				assets.get_child(4).get_child(0).playing = true
				playedEffect = true
			getAsset(Assets.PLAYER_SPRITE).visible = true
			UI.get_child(1).get_child(1).health = playerHealth
		elif (timer >= 0):
			getAsset(Assets.PLAYER_SPRITE).visible = false
	return 0
	
func winInit():
	currentState = GameState.WIN
	get_child(3).get_child(0).visible = true
	click = false
	return 0

func win():
	if (click):
		get_child(3).get_child(0).visible = false
		jsonString = JSON.stringify(jsonData)
		jsonFile.store_string(jsonString)
	
		get_tree().change_scene_to_file("res://scenes/Cutscene.tscn")
		currentEnemy = currentEnemy + 1
		UI.get_child(1).get_child(1).health = UI.get_child(1).get_child(1).maxHealth
		chooseAttackinit()
	return 0
	
func loseInit():
	currentState = GameState.LOSE
	get_child(3).get_child(1).visible = true
	click = false
	return 0
	
func lose():
	if (click):
		get_child(3).get_child(1).visible = false
		jsonString = JSON.stringify(jsonData)
		jsonFile.store_string(jsonString)
		
		get_tree().change_scene_to_file("res://scenes/Cutscene.tscn")
		UI.get_child(1).get_child(1).health = UI.get_child(1).get_child(1).maxHealth
		chooseAttackinit()
	return 0
	
var click: bool
	
func _input(event):
	if (event.is_action_released("click")):
		click = true

var enemyChanged: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not(currentEnemyName == assets.get_child(0).get_child(currentEnemy).characterName)):
		enemyChanged = true
	else:
		enemyChanged = false
	
	if (enemyChanged):
		for i in range(6):
			assets.get_child(0).get_child(i).visible = false
		currentEnemyName = assets.get_child(0).get_child(currentEnemy).characterName
		assets.get_child(0).get_child(currentEnemy).visible = true
		UI.get_child(2).get_child(1).maxHealth = assets.get_child(0).get_child(currentEnemy).health
		UI.get_child(2).get_child(1).health = assets.get_child(0).get_child(currentEnemy).health
	
	for i in range(4):
		assets.get_child(2).get_child(i).visible = false
		
	currentBackDrop = assets.get_child(0).get_child(currentEnemy).background
	assets.get_child(2).get_child(currentBackDrop).visible = true
	
	for i in range(6):
		if (i == assets.get_child(0).get_child(currentEnemy).music):
			if (assets.get_child(3).get_child(i).playing == false):
				assets.get_child(3).get_child(i).playing = true
		else:
			assets.get_child(3).get_child(i).playing = false
		
	match (currentState):
		GameState.CHOOSE_ATTACK:
			pass
		GameState.PLAYER_ATTACK:
			playerAttack(delta)
		GameState.ENEMY_ATTACK:
			enemyAttack(delta)
		GameState.WIN:
			win()
		GameState.LOSE:
			lose()
	pass

func _on_fight_button_1_pressed():
	playerAttackInit(Attacks.MONEY_STORM)

func _on_fight_button_2_pressed():
	playerAttackInit(Attacks.RIZZ)

func _on_fight_button_3_pressed():
	playerAttackInit(Attacks.GREEN_LIGHT)
