extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var some = self.stream.data
	print(some.size())
	var sum = 0
	for elem in some.subarray(176389 * 30, 176389 * 31):
		sum += elem
	print(sum)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
