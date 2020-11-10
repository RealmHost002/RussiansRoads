extends VehicleBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gas = 0
var turn = 0
var rot = 0
var optimal_speed = [5, 10, 15, 20, 25 , 30]
var gear = -1
var gearstate = 5
var current_stickstate = Vector2(0,0)
var stickstate = Vector2(0,0)
var right = Vector3(0,0,0)
var working = false
var clutch = false
var gear_cracked = false
var gearbox_crack_sound = load("res://sound/gearbox_crack.ogg")
var gear_sound1 = load("res://sound/change_gear1.ogg")
var gear_sound2 = load("res://sound/change_gear2.ogg")
var stalled_sound = load("res://sound/stalled1.ogg")
var engine_sound = load("res://sound/starting_engine.ogg")
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	load_curves()
#	print(range_curves[0].interpolate(0.3))
	pass # Replace with function body.
func _input(event):
#	if event is InputEventMouseMotion:
#		self.steering = -(event.position.x - 500)/500
#		self.engine_force = -(event.position.y - 300)/5
	if event.is_action_pressed("gear_up"):
		gear += 1
		print(gear)
	if event.is_action_pressed("gear_down"):
		gear -= 1
		print(gear)
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


		################GEARS################
	if (event.is_action_pressed("gearU") or event.is_action_pressed("gearD") or event.is_action_pressed("gearUR") or event.is_action_pressed("gearUL") or event.is_action_pressed("gearR") or event.is_action_pressed("gearL") or event.is_action_pressed("gearDR") or event.is_action_pressed("gearDL") or event.is_action_pressed("gearM")) and !clutch:
		gearbox_crack()
		return
		
		
	if (event.is_action_pressed("gearU") or event.is_action_pressed("gearD") or event.is_action_pressed("gearUR") or event.is_action_pressed("gearUL") or event.is_action_pressed("gearR") or event.is_action_pressed("gearL") or event.is_action_pressed("gearDR") or event.is_action_pressed("gearDL") or event.is_action_pressed("gearM")) and (!clutch or gear_cracked):
		
		return
#	if (event.is_action_pressed("gearU") or event.is_action_pressed("gearD") or event.is_action_pressed("gearUR") or event.is_action_pressed("gearUL") or event.is_action_pressed("gearR") or event.is_action_pressed("gearL") or event.is_action_pressed("gearDR") or event.is_action_pressed("gearDL") or event.is_action_pressed("gearM")) and !clutch:
#		gearbox_crack()


	if event.is_action_pressed("gearU"):
		if gearstate == 5:
			gearstate = 8
			gear = 2
		else:
			gearbox_crack()
			
	if event.is_action_pressed("gearD"):
		if gearstate == 5:
			gearstate = 2
			gear = 3
		else:
			gearbox_crack()
	if event.is_action_pressed("gearUR"):
		if gearstate == 6:
			gearstate = 9
			gear = 4
		else:
			gearbox_crack()
	if event.is_action_pressed("gearUL"):
		if gearstate == 4:
			gearstate = 7
			gear = 0
		else:
			gearbox_crack()
	if event.is_action_pressed("gearR"):
		if gearstate == 5:
			gearstate = 6
			gear = -1
		elif gearstate == 3:
			gearstate = 6
			gear = -1
		elif gearstate == 9:
			gearstate = 6
			gear = -1
		else:
			gearbox_crack()
	if event.is_action_pressed("gearL"):
		if gearstate == 5:
			gearstate = 4
			gear = -1
		elif gearstate == 7:
			gearstate = 4
			gear = -1
		elif gearstate == 1:
			gearstate = 4
			gear = -1
		else:
			gearbox_crack()
	if event.is_action_pressed("gearDR"):
		if gearstate == 6:
			gearstate = 3
			gear = 5
		else:
			gearbox_crack()
	if event.is_action_pressed("gearDL"):
		if gearstate == 4:
			gearstate = 1
			gear = 1
		else:
			gearbox_crack()
	if event.is_action_pressed("gearM"):
		if gearstate == 4 or gearstate == 8 or gearstate == 6 or gearstate == 2:
			gearstate = 5
			gear = -1
		else:
			gearbox_crack()
	
	
	if event.is_action_pressed("starter"):
		if gear == -1 or clutch:
			working = !working
			get_node("AudioStreamPlayer").stream = engine_sound
			get_node("AudioStreamPlayer").play()
	if event.is_action_pressed("clutch") or event.is_action_released("clutch"):
		clutch = !clutch
	
	
	
	if (event.is_action_pressed("gearU") or event.is_action_pressed("gearD") or event.is_action_pressed("gearUR") or event.is_action_pressed("gearUL") or event.is_action_pressed("gearR") or event.is_action_pressed("gearL") or event.is_action_pressed("gearDR") or event.is_action_pressed("gearDL") or event.is_action_pressed("gearM")) and clutch and !gear_cracked:
		anim_gearstate(gearstate)
		print('animed')
	
func gearbox_crack():
	print('cracked')
	gear_cracked = true
	get_node("gear_crack_timer").start()
	get_node("gear_sound").stream = gearbox_crack_sound
	get_node("gear_sound").play()
	pass
	
func crack():
	get_node("AudioStreamPlayer").stream = stalled_sound
	get_node("AudioStreamPlayer").play()
	working = false
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	time += delta
#	print(time)
	right = (get_node("right").global_transform.origin - self.global_transform.origin).normalized()
	rot = lerp(rot, turn, delta * 60 * 0.1)
	steering = -rot * 0.5
	current_stickstate = lerp(current_stickstate, stickstate, 0.1)
	get_node("vasya").get_node("AnimationTree").set("parameters/blend_position", current_stickstate)





	brake = 0
	if !working:
		if !clutch:
			brake = 100
		return
	
	var speed = self.linear_velocity.length()
	var spd_dif = 0
	if gear != -1 and gear != 5:
		spd_dif = range_curves[gear].interpolate(speed * 3.6 / 100.0)
	elif gear == 5:
		gas = -1
		spd_dif = 1
	else:
		gas = 1
#	if gear > 0:
#		spd_dif = (optimal_speed[gear] - speed) / 10.0
#	if sign(self.linear_velocity.cross(right).y) > 0:
		
	if spd_dif < -1.1:
		crack()

#	clamp(self.linear_velocity.length() / 8, 1, 2)
	if gas:
		engine_force = gas * 200 * clamp(spd_dif, -1 , 1) * int(!clutch)
	else:
		engine_force = 0
	
	
#	current_stickstate = lerp(current_stickstate, stickstate, 0.1)
#	get_node("vasya").get_node("AnimationTree").set("parameters/blend_position", current_stickstate)
#	print(self.linear_velocity.length() * 3.6, '     ', clamp(spd_dif, -1 , 1), '   gear    ' , gear)
	pass

func anim_gearstate(state):
#	print(state)
#	print(get_node("vasya").get_node("AnimationTree").get("parameters/blend_position"))
	if gearstate == 7:
		get_node("gear_sound").stream = gear_sound2
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position", Vector2(-1,1))
		stickstate = Vector2(-1,1)
		
	if gearstate == 4:
		get_node("gear_sound").stream = gear_sound1
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position", Vector2(-1,0))
		stickstate = Vector2(-1,0)
		
	if gearstate == 1:
		get_node("gear_sound").stream = gear_sound2
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position", Vector2(-1,-1))
		stickstate = Vector2(-1,-1)
		
	if gearstate == 9:
		get_node("gear_sound").stream = gear_sound2
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position",  Vector2(1,1))
		stickstate = Vector2(1,1)
		
	if gearstate == 6:
		get_node("gear_sound").stream = gear_sound1
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position",  Vector2(1,0))
		stickstate = Vector2(1,0)
		
	if gearstate == 3:
		get_node("gear_sound").stream = gear_sound2
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position",  Vector2(1,-1))
		stickstate = Vector2(1,-1)
		
	if gearstate == 8:
		get_node("gear_sound").stream = gear_sound2
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position",  Vector2(0,1))
		stickstate = Vector2(0,1)
		
	if gearstate == 5:
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position",  Vector2(0,0))
		stickstate =  Vector2(0,0)
	
	if gearstate == 2:
		get_node("gear_sound").stream = gear_sound2
		get_node("gear_sound").play()
#		get_node("vasya").get_node("AnimationTree").set("parameters/blend_position",  Vector2(0,-1))
		stickstate = Vector2(0,-1)
var range_curves = []
func load_curves():
	for i in range(5):
		i += 1
		range_curves.append(load("res://curves/" + str(i) + ".tres"))
	


func _on_gear_crack_timer_timeout():
	gear_cracked = false
	get_node("gear_crack_timer").stop()
