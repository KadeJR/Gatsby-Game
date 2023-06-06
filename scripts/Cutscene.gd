extends Node2D

@export var currentCutscene: Cutscenes

enum Cutscenes{
	WOLFSHEIM_EVOLUTION = 0,
	DAISY_GATSBY_HOUSE = 1,
	TOM_BUCHANNAN_HOUSE = 2,
	TOM_CITY = 3,
	CAR_WILSON_POOL = 4,
	END = 5,
}

enum FrameType {
	STATIC,
	ANIMATION
}

var click: bool

var frames: Array[Node]
var currentFrameIndex: int
var currentFrame: Node


func playCutscene():
	
	# make the correct frame visible
	frames = get_child(currentCutscene).get_children()
	currentFrame = frames[currentFrameIndex]
	
	for i in range(6):
		if (i == frames[currentFrameIndex].music):
			if (get_child(get_child_count() - 1).get_child(i).playing == false):
				get_child(get_child_count() - 1).get_child(i).playing = true
		else:
			get_child(get_child_count() - 1).get_child(i).playing = false

	
	for i in frames:
		if (i == currentFrame):
			get_child(get_child_count() - 2).get_child(0).text = i.textBoxText
			for x in i.get_children():
				x.visible = true
		else:
			for x in i.get_children():
				x.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	click = false
	currentFrameIndex = 0
	var jsonString = FileAccess.get_file_as_string("user://save.json")
	var jsonData = {}
	jsonData = JSON.parse_string(jsonString)
	
	currentCutscene = jsonData["currentEnemy"] - 1
	pass # Replace with function body.

func _input(event):
	if (event.is_action_released("click")):
		click = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#checks # of clicks
	if (click):
		currentFrameIndex += 1
	click = false
	
	if (currentFrameIndex == get_child(currentCutscene).get_child_count() and currentCutscene == Cutscenes.END ):
		get_tree().quit()
	
	#checks if cutscene is done
	if (get_child(currentCutscene).get_child_count() <= currentFrameIndex):
		currentFrameIndex = 0
		currentCutscene = currentCutscene + 1
		get_tree().change_scene_to_file("res://scenes/fight.tscn")
	else:
		playCutscene()
	
	pass
