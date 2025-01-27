extends Object
class_name VectorHandler

enum FollowMode {BOTH, MOUSE_MODE, DIRECTION_MODE}
enum MainRememberedPosition {DIRECTION, USERINPUT}

var target_object: Node3D
var follower_object: Node3D
var inertia: Inertia
var mouse_cache: MouseCache

func _init(t_o: Node3D, f_o: Node3D, i: Inertia) -> void:
	target_object = t_o
	follower_object = f_o
	inertia = i
	mouse_cache = inertia.mouse_cache

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
	
	elif not inertia.is_inertia():
		return mouse_cache.last_mouse_input_camera_position
		
	else:
		return follower_object.position

func direction_in_range(trigger: float) -> bool:
	return abs(target_object.direction.x) < trigger\
	and abs(target_object.direction.y) < trigger\
	and abs(target_object.direction.z) < trigger
