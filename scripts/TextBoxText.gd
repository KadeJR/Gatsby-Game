extends RichTextLabel

var textCont: String

# Called when the node enters the scene tree for the first time.
func _ready():
	textCont = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = textCont
	pass
