extends TextureButton


# Declare member variables here. Examples:
var link = "res://trees/house.tscn"
var type = 'house'
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_button_down():
	for button in get_parent().get_children():
		if button != self:
			button.pressed = false
	get_node("../../../../Camera").path_to_node = self.link
	get_node("../../../../Camera").node_type = self.type
	pass # Replace with function body.
