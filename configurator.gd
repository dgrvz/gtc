extends Object
class_name Configurator

var follower_object: Node3D
var target_object: Node3D
var mouse_handler: MouseHandler
var direction_handler: DirectionHandler
var interpolator: InterpolationManager

func _init(
	t_o: Node3D,
	f_o: Node3D,
	m_handler: MouseHandler,
	d_handler: DirectionHandler,
	interpol: InterpolationManager
	) -> void:
	
	target_object = t_o
	follower_object = f_o
	mouse_handler = m_handler
	direction_handler = d_handler
	interpolator = interpol

func setup_default_position() -> void:
	follower_object.position.z = follower_object.distance
	follower_object.position.y = follower_object.height_offset
	mouse_handler.last_mouse_input_camera_position = follower_object.position
	
	if interpolator.rotation_interpolation_mode !=\
	InterpolationManager.RotationInterpolationMode.LOOK_AT:
			
		follower_object.rotation.x = follower_object.horizontal_default_rotation
	else:
		follower_object.look_at(target_object.global_position)

func configure_follow_mode() -> void:
	match follower_object.follow_mode:
		
		DirectionHandler.FollowMode.MOUSE_MODE:
			mouse_handler.save_mouse_input_position = true
			direction_handler.main_remembered_position =\
			DirectionHandler.MainRememberedPosition.USERINPUT
			
		DirectionHandler.FollowMode.DIRECTION_MODE:
			mouse_handler.save_mouse_input_position = false
			direction_handler.main_remembered_position =\
			DirectionHandler.MainRememberedPosition.DIRECTION
			
		DirectionHandler.FollowMode.BOTH:
			mouse_handler.save_mouse_input_position = true
