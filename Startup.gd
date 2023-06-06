extends Node

var jsonFile: FileAccess
var jsonString
var jsonData

# Called when the node enters the scene tree for the first time.
func _ready():
	jsonFile = FileAccess.open("user://save.json", FileAccess.READ_WRITE)
	
	jsonString = jsonFile.get_as_text()
	jsonData = {}
	jsonData = JSON.parse_string(jsonString)
	
	jsonData["currentEnemy"] = 1
	
	jsonString = JSON.stringify(jsonData)
	
	jsonFile.store_string(jsonString)
	
	get_tree().change_scene_to_file("res://scenes/Cutscene.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
