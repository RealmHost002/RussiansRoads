extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _input(event):
	if event is InputEventMouseMotion:
		print(event.relative)
		self.rotation_degrees.y -= event.relative.x / 15.0
		self.rotation_degrees.x -= event.relative.y / 15.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
