extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var trees_poses = []
# Called when the node enters the scene tree for the first time.
func _ready():
#	return
	var saveFile = File.new()
	saveFile.open("res://trees_pos.json", File.READ)
	var ourTeamDataJson =JSON.parse(saveFile.get_as_text())
	saveFile.close()
	trees_poses = ourTeamDataJson.result
	for obj_data in trees_poses:
		var obj_node = load(obj_data['link']).instance()
		self.add_child(obj_node)
		obj_node.global_transform.origin = Vector3(obj_data['x'], obj_data['y'], obj_data['z'])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
