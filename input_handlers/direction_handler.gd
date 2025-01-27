extends Node
class_name DirectionHandler

enum FollowMode {BOTH, MOUSE_MODE, DIRECTION_MODE}
enum MainRememberedPosition {DIRECTION, USERINPUT}

var target_object: Node3D
var follower_object: Node3D
var mouse_handler: MouseHandler

func _init(t_o: Node3D, f_o: Node3D, m_handler: MouseHandler) -> void:
	target_object = t_o
	follower_object = f_o
	mouse_handler = m_handler

func get_position_from_direction() -> Vector3:
	if not direction_in_range(follower_object.change_position_trigger)\
	and follower_object.follow_mode != FollowMode.MOUSE_MODE:
			
		return Vector3(
			-target_object.direction.x * follower_object.distance,
			follower_object.height_offset,
			-target_object.direction.z * follower_object.distance
		)
	
	elif direction_in_range(follower_object.change_position_trigger)\
	and follower_object.main_remembered_position == MainRememberedPosition.DIRECTION:
		
		return follower_object.position
	
	elif is_mouse_inertia():
		return mouse_handler.last_mouse_input_camera_position
		
	else:
		return follower_object.position

func direction_in_range(trigger: float) -> bool:
	return abs(target_object.direction.x) < trigger\
	and abs(target_object.direction.y) < trigger\
	and abs(target_object.direction.z) < trigger

func is_mouse_inertia() -> bool:
	var inertia_is_upper_than_min_inertia_velocity: bool =\
	mouse_handler.inertia_velocity.length() < follower_object.minimal_velocity
	
	var not_breakdown_inertia_with_saved_position: bool =\
	mouse_handler.inertia_velocity.length() < follower_object.save_userinput_position_while_inertia
	
	return inertia_is_upper_than_min_inertia_velocity or not_breakdown_inertia_with_saved_position
