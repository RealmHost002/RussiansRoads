extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var trees_poses = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var saveFile = File.new()
	saveFile.open("res://trees_pos.json", File.READ)
	var ourTeamDataJson =JSON.parse(saveFile.get_as_text())
	saveFile.close()
	trees_poses = ourTeamDataJson.result
	for pos in trees_poses:
		var tree_node = load("res://trees/birch2.tscn").instance()
		self.add_child(tree_node)
		tree_node.global_transform.origin = Vector3(pos[0], pos[1], pos[2])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
