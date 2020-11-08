extends Camera


# Declare member variables here. Examples:
var last_tree
var tree_poses = []
var trees = []
var move = Vector3(0,0,0)
var rotation_ = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	

func _input(event):
	if !self.current:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
		
#	if event is InputEventMouseMotion:
#		self.rotation_degrees.y -= event.relative.x / 15.0
#		self.rotation_degrees.x -= event.relative.y / 15.0
	if event.is_action_pressed("left_click"):
		var from = self.project_ray_origin(event.position)
		var to = from + self.project_ray_normal(event.position) * 150
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to)
		print(result)
		if result:
			var tree_node = load("res://trees/birch2.tscn").instance()
			get_parent().add_child(tree_node)
			tree_node.global_transform.origin = result['position']
			trees.append(tree_node)
			tree_poses.append(result['position'])

	if event.is_action_pressed("right_click"):
#		print(trees)
		trees[-1].queue_free()
		trees.pop_back()
		tree_poses.pop_back()
		
	if event.is_action_pressed("ui_left"):
		move.x += 1 
	if event.is_action_pressed("ui_right"):
		move.x -= 1 
	if event.is_action_released("ui_right"):
		move.x += 1
	if event.is_action_released("ui_left"):
		move.x -= 1
		
		
	if event.is_action_pressed("ui_up"):
		move.z += 1 
	if event.is_action_pressed("ui_down"):
		move.z -= 1 
	if event.is_action_released("ui_up"):
		move.z -= 1
	if event.is_action_released("ui_down"):
		move.z += 1 
	if event.is_action_pressed("interact"):
		var arr_to_save = []
		var save_file = File.new()
		save_file.open("res://trees_pos.json", File.WRITE)
		for pos in tree_poses:
			var p = [pos.x, pos.y, pos.z]
			arr_to_save.append(p)
			
		save_file.store_string(to_json(arr_to_save))
		save_file.close()
	
	
	if event.is_action_pressed("clutch"):
		rotation_ = 1
	if event.is_action_pressed("starter"):
		rotation_ = -1
	if event.is_action_released("starter") or event.is_action_released("clutch"):
		rotation_ = 0
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_transform.origin -= move.rotated(Vector3(0,1,0), self.rotation.y) * delta * 25
	self.rotate_y(rotation_ * delta)
