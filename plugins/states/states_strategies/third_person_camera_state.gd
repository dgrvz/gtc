class_name ThirdPersonCameraState
extends IState

func input_update(event) -> void:
	if event is InputEventMouseMotion\
	and (GTC._camera_settings.without_key or Input.is_action_pressed(GTC._camera_settings.capture_key)):
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		GTC._mouse_input_handler.handle_mouse_input(event)
		var desired_position_vector: Vector3 = GTC._mouse_input_handler.get_transformed(GTC._transform_component)
		GTC._inertia_processor.calculate_inertia_velocity(GTC._transform_component.get_position(), desired_position_vector)


func physics_update(delta) -> void:
	if not Input.is_action_pressed(GTC._camera_settings.capture_key):
		if not GTC._camera_settings.without_key:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		GTC._mouse_input_handler.transform(GTC._transform_component, GTC._position_interpolator, GTC._rotation_interpolator, GTC._inertia_processor)
		GTC._target_direction_handler.transform(GTC._transform_component, GTC._position_interpolator, GTC._rotation_interpolator, GTC._inertia_processor)
