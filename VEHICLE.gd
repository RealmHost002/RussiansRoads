extends VehicleBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gas = 0
var turn = 0
var rot = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _input(event):
#	if event is InputEventMouseMotion:
#		self.steering = -(event.position.x - 500)/500
#		self.engine_force = -(event.position.y - 300)/5
#		print(event.position)
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
	if event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		gas = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gas:
		engine_force = gas * 100
	else:
		engine_force = 0
	
#	steering = turn * -0.5
	rot = lerp(rot, turn, delta * 60 * 0.1)
	steering = -rot * 0.5
#	steering
#	engine_force = 100
	pass
