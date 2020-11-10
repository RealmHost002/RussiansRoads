extends Camera


# Declare member variables here. Examples:
var last_tree
var tree_poses = []
var trees = []
var move = Vector3(0,0,0)
var rotation_ = 0


var choosen_object
var obj_mode = 'nothing'

var move_or_rot = 'rot'
var move_mode = false

var path_to_node = "res://trees/birch2.tscn"
var node_type
# Called when the node enters the scene tree for the first time.
func _ready():
#	if !self.current:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		return
	show_curve(get_node("../../Path").curve)
	pass # Replace with function body.
	

func _input(event):
	if !self.current:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	if event.is_action_pressed("special_1_for_edit_mode"):
		move_or_rot = 'move'
	if event.is_action_released("special_1_for_edit_mode"):
		move_or_rot = 'rot'
	if event.is_action_pressed("special_2_for_edit_mode"):
		move_mode = true
	if event.is_action_released("special_2_for_edit_mode"):
		move_mode = false
	if event is InputEventMouseMotion and move_mode:
		if move_or_rot == 'move':
			var forward
			var right = get_node("../right").global_transform.origin - get_parent().global_transform.origin
			var up = get_node("../up").global_transform.origin - get_parent().global_transform.origin
			get_parent().global_transform.origin += (up * event.relative.y - right * event.relative.x) * self.transform.origin.length() / 150.0
		if move_or_rot == 'rot':
			get_parent().rotation_degrees.y -= event.relative.x / 7.0
			get_parent().rotation_degrees.x -= event.relative.y / 7.0
	
	
	#######ADDITEMONMAP############
	
	if event.is_action_pressed("left_click"):
		var from = self.project_ray_origin(event.position)
		var to = from + self.project_ray_normal(event.position) * 150
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to)
		if result:
			if result['collider'] in get_tree().get_nodes_in_group('obstacles'):
				choosen_object = result['collider']
			else:
				var obj_node = load(path_to_node).instance()
				get_parent().get_parent().get_node("trees").add_child(obj_node)
				obj_node.global_transform.origin = result['position']
				obj_node.add_to_group('obstacles')
				obj_node.link = path_to_node
				obj_node.rotation.y = randf() * PI * 2
				choosen_object = obj_node
#			trees.append(tree_node)
#			tree_poses.append(result['position'])

	if event.is_action_pressed("right_click"):
		var from = self.project_ray_origin(event.position)
		var to = from + self.project_ray_normal(event.position) * 150
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to)
		if result:
			if result['collider'] in get_tree().get_nodes_in_group('obstacles'):
				result['collider'].queue_free()
		
	if event.is_action_pressed("edit_mode_camera_in"):
		self.transform.origin *= 0.9
	if event.is_action_pressed("edit_mode_camera_out"):
		self.transform.origin *= 1.1
		
		
	if choosen_object:
		if event.is_action_pressed("ui_down"):
			obj_mode = 'scale'
		if event.is_action_released("ui_down"):
			obj_mode = 'nothing'
		if event.is_action_pressed("starter"):
			obj_mode = 'rot'
		if event.is_action_released("starter"):
			obj_mode = 'nothing'
		if event.is_action_pressed("edit_move_mode"):
			obj_mode = 'move'
		if event.is_action_released("edit_move_mode"):
			obj_mode = 'nothing'
		
		
		
		
		if event is InputEventMouseMotion:
			if obj_mode == 'rot':
				choosen_object.rotate_y(event.relative.x / 55.0)
			if obj_mode == 'scale':
				choosen_object.scale += Vector3(1,1,1) * event.relative.x / 55.0
			if obj_mode == 'move':
				var right = get_node("../right").global_transform.origin - get_parent().global_transform.origin
				var up = get_node("../up").global_transform.origin - get_parent().global_transform.origin
				choosen_object.global_transform.origin -= (up * event.relative.y - right * event.relative.x) * self.transform.origin.length() / 550.0




#	if event.is_action_pressed("ui_left"):
#		move.x += 1 
#	if event.is_action_pressed("ui_right"):
#		move.x -= 1 
#	if event.is_action_released("ui_right"):
#		move.x += 1
#	if event.is_action_released("ui_left"):
#		move.x -= 1
		
		
#	if event.is_action_pressed("ui_up"):
#		move.z += 1 
#	if event.is_action_pressed("ui_down"):
#		move.z -= 1 
#	if event.is_action_released("ui_up"):
#		move.z -= 1
#	if event.is_action_released("ui_down"):
#		move.z += 1 
	if event.is_action_pressed("special_3_for_edit_mode"):
		var arr_to_save = []
		var save_file = File.new()
		save_file.open("res://trees_pos.json", File.WRITE)
		for child in get_node("../../trees").get_children():
			var t = child.global_transform.origin
			var type = 0
			var p = {'x' : t.x, 'y' : t.y,  'z' : t.z, "r" : child.rotation.y, 'link' : child.link, 's' : child.scale.x}
			
			arr_to_save.append(p)
			
		save_file.store_string(to_json(arr_to_save))
		save_file.close()
	

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !self.current:
		return
#	get_node("../../Path").curve.set_point_position(4, Vector3(0,0,0))
	get_node("../axises").global_transform.basis = Basis.IDENTITY
	self.global_transform.origin -= move.rotated(Vector3(0,1,0), self.rotation.y) * delta * 25
	self.rotate_y(rotation_ * delta)



func show_curve(curve):
	return
	for i in range(curve.get_point_count()):
		var pos = curve.get_point_position(i)
		var dot = load("res://world_redactor/curve_tool/pos.tscn").instance()
		get_node("../../curve_show_node").add_child(dot)
		dot.global_transform.origin = pos
		
		var in_pos = curve.get_point_in(i)
		dot = load("res://world_redactor/curve_tool/in.tscn").instance()
		get_node("../../curve_show_node").add_child(dot)
		dot.global_transform.origin = pos + in_pos
		
		var out_pos = curve.get_point_out(i)
		dot = load("res://world_redactor/curve_tool/out.tscn").instance()
		get_node("../../curve_show_node").add_child(dot)
		dot.global_transform.origin = pos + out_pos
		
		i -= 1
		if i >= 0:
			pos = (curve.get_point_position(i) + curve.get_point_position(i+1))/2
#			var next_pos = curve.get_point_position(i+1)
			dot = load("res://world_redactor/curve_tool/add.tscn").instance()
			get_node("../../curve_show_node").add_child(dot)
			dot.global_transform.origin = pos

