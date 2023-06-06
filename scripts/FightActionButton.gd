extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fight_button_toggled(button_pressed):
	self.visible = not self.visible
	pass # Replace with function body.
