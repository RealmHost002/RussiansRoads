extends Spatial


# Declare member variables here. Examples:
var state = 'camera_on_road'
var on_window = false
var anim_node
var smoke = 0
var timer


var some_for_lerp = 0


# Called when the node enters the scene tree for the first time.
func _ready():
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
			anim_node['parameters/TimeScale/scale'] = 1
			anim_node['parameters/smoking_mix/blend_amount'] = 1.0
			timer.wait_time = 2.2
			timer.start()
		else:
			anim_node['parameters/TimeScale/scale'] = 1
			anim_node['parameters/smoking_mix/blend_amount'] = 0.0
			timer.wait_time = 3
			timer.start()
	
	
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim_node['parameters/final_mix/blend_amount'] = lerp(anim_node['parameters/final_mix/blend_amount'], some_for_lerp, 0.1)
	pass


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
