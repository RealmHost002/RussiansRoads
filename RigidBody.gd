extends RigidBody


# Declare member variables here. Examples:
var forward = Vector3()
var gas = 0
var turn = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_up"):
		gas = 1.0
	if event.is_action_pressed("ui_down"):
		gas = -1.0
	if event.is_action_pressed("ui_right"):
		turn = 1.0
	if event.is_action_pressed("ui_left"):
		turn = -1.0
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		turn = 0
func _integrate_forces(state):
	forward = (get_node("Position3D").global_transform.origin - self.global_transform.origin).normalized()
	
	state.add_force(forward * 10.0 * gas, Vector3(0,0,0))
	state.add_torque(Vector3(0, turn * 3, 0))
	print(turn)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
