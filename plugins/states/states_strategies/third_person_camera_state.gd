class_name ThirdPersonCameraState
extends IState

func input_update(event) -> void:
	if event is InputEventMouseMotion\
	and (GTC._camera_settings.without_key or Input.is_action_pressed(GTC._camera_settings.capture_key)):
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		GTC.get_mouse_input_handler().handle_mouse_input(event)
		var desired_position_vector: Vector3 = GTC.get_mouse_input_handler().get_transformed(GTC.get_transform_component())
		GTC.get_inertia_processor().calculate_inertia_velocity(GTC.get_transform_component().get_position(), desired_position_vector)

func physics_update(delta) -> void:
	if not Input.is_action_pressed(GTC._camera_settings.capture_key):
		if not GTC._camera_settings.without_key:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		if abs(GTC.get_mouse_input_handler().mouse_move_x) > 0.01 and abs(GTC.get_mouse_input_handler().mouse_move_y) > 0.001: # numbers from mouse settings (horizontal and vertical sensetivity)
			GTC.get_mouse_input_handler().transform(GTC.get_transform_component(), GTC.get_position_interpolator(), GTC.get_rotation_interpolator(), GTC.get_inertia_processor())
		else:
			GTC.get_target_direction_handler().transform(GTC.get_transform_component(), GTC.get_position_interpolator(), GTC.get_rotation_interpolator(), GTC.get_inertia_processor())
