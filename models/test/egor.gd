extends Spatial


# Declare member variables here. Examples:
var state = 'camera_on_road'
var on_window = false
var anim_node
var smoke = 0
var timer

var time_to_stryahivat = 0
var time_to_smoke = 0
var time_to_progress_bar = 0
var some_for_lerp = 0
var gui_node
var pora_pokurit
var siga_progress_value
var count_of_puff = 0

func _ready():
	gui_node = get_tree().get_root().get_node("Spatial/Gui")
	siga_progress_value = get_tree().get_root().get_node("Spatial/Gui").get_node("TextureProgress")
	anim_node = get_node("AnimationTree")
	timer = get_node("Timer")
	pass # Replace with function body.
func _input(event):
	if timer.time_left:
		print(timer.time_left)
		return
	if event.is_action_pressed("right_click"):
		if state == 'camera_on_road':
			anim_node['parameters/TimeScale/scale'] = 0
			some_for_lerp = 1
#			anim_node['parameters/final_mix/blend_amount'] = 1
			state = 'camera_behind'

	if event.is_action_pressed("left_click"):
		if state == 'camera_behind':
			anim_node['parameters/TimeScale/scale'] = 0
			some_for_lerp = 0
#			anim_node['parameters/final_mix/blend_amount'] = 0.0
			state = 'camera_on_road'

	if event.is_action_pressed("interact"):
		if on_window:
#			return
			count_of_puff = 0
			anim_node['parameters/TimeScale/scale'] = 1
			anim_node['parameters/smoking_mix/blend_amount'] = 1.0
			timer.wait_time = 2.2
			timer.start()
		else:
			count_of_puff += 1
			if count_of_puff == 3:
				gui_node.get_node("TextureProgress/Label").text = "You need to shake off the ash!"
			if count_of_puff == 4:
				gui_node.get_node("TextureProgress/Label").text = "Pezda"	
			gui_node.get_node("Control").hide()
			anim_node['parameters/TimeScale/scale'] = 1
			anim_node['parameters/smoking_mix/blend_amount'] = 0.0
			timer.wait_time = 3
			timer.start()
			time_to_smoke = 0
			siga_progress_value.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim_node['parameters/final_mix/blend_amount'] = lerp(anim_node['parameters/final_mix/blend_amount'], some_for_lerp, 0.1)
	time_to_progress_bar += delta
	time_to_smoke += delta
	if not on_window :
		gui_node.get_node("Control").hide()
	if	time_to_smoke >= 0.2:
		siga_progress_value.value +=1
		time_to_smoke = 0
	if siga_progress_value.value < 100 and siga_progress_value.value >= 70 and count_of_puff != 3:
		gui_node.get_node("TextureProgress/Label").text = "Egor goes carzy"
		pora_pokurit = true
		gui_node.get_node("Control").show()
		gui_node.get_node("Control/Label").text = "press wheel to smoke"
	if siga_progress_value.value < 70 and siga_progress_value.value >= 50 and count_of_puff != 3:
		gui_node.get_node("TextureProgress/Label").text = "Egor wants to smoke"
	if siga_progress_value.value < 50 and siga_progress_value.value >= 30 and count_of_puff != 3:
		gui_node.get_node("TextureProgress/Label").text = "Egor feel nervous"
	if siga_progress_value.value < 30 and siga_progress_value.value >= 0 and count_of_puff != 3:
		gui_node.get_node("TextureProgress/Label").text = "Egor is fine"  	
	if siga_progress_value.value == 100:
		gui_node.get_node("TextureProgress/Label").text = "Pizda" 
	if on_window :
		gui_node.get_node("Control").show()
		gui_node.get_node("Control/Label").text = "press wheel to shake off"
		
func _on_Timer_timeout():
	anim_node['parameters/smoking_mix/blend_amount'] = 0.0
	anim_node['parameters/TimeScale/scale'] = 0
	anim_node['parameters/SeekSmoke/seek_position'] = 0
#	anim_node['parameters/SeekStryah/seek_position'] = 0
#	anim_node['parameters/smoking_mix/blend_amount'] = 0.0
	print('time_out')
	pass # Replace with function body.





func _on_window_mouse_entered():
	on_window = true
	print('some')
	pass # Replace with function body.


func _on_window_mouse_exited():
	on_window = false
	pass # Replace with function body.
