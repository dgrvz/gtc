extends Object
class_name MouseHandler

var inertia_velocity: Vector3 = Vector3.ZERO
var save_mouse_input_position: bool
var last_mouse_input_camera_position: Vector3 = Vector3.BACK
var last_mouse_velocity: float = 0.0
var mouse_move_x: float = 0.0
var mouse_move_y: float = 0.0

var target_object: Node3D
var follower_object: Node3D
var horizontal_mouse_sensitivity: float
var vertical_mouse_sensitivity: float

func _init(t_o: Node3D, f_o: Node3D, h_sens: float, v_sens: float) -> void:
	target_object = t_o
	follower_object = f_o
	horizontal_mouse_sensitivity = h_sens
	vertical_mouse_sensitivity = v_sens

func get_rotated_radius_vector(horizontal_radians: float, vertical_radians: float) -> Vector3:
									
	var phi: float = InterpolationManager.point_to_radians(
															follower_object.position.x,
															follower_object.position.z
														)
	
	var theta: float = acos(follower_object.position.y / follower_object.distance)
	
	var x: float = follower_object.distance * sin(phi - horizontal_radians)
	var y: float = follower_object.height_offset
	var z: float = follower_object.distance * cos(phi - horizontal_radians)
	
	if follower_object.unlock_horizontal_position_axis:
		x *= sin(theta + vertical_radians)
		y = clamp(
					follower_object.distance * cos(theta - vertical_radians),
					follower_object.min_vertical_angle,
					follower_object.max_vertical_angle
				)
		z *= sin(theta + vertical_radians)
	
	return Vector3(x, y, z)

func delay_before_inertion(weight) -> void:
	# NOTE necessarily call this before inertia
	last_mouse_velocity = lerp(last_mouse_velocity, 0.0, weight)

func save_mouse_velocity(event: InputEvent) -> void:
	mouse_move_x = clamp(event.screen_relative.x, -100, 100) * horizontal_mouse_sensitivity
	mouse_move_y = clamp(event.screen_relative.y, -100, 100) * vertical_mouse_sensitivity
	last_mouse_velocity = Input.get_last_mouse_velocity().length()

func store_mouse_input_position(pos: Vector3) -> void:
	if save_mouse_input_position:
		last_mouse_input_camera_position = pos

func apply_mouse_inertion(vector: Vector3) -> Vector3:
	if follower_object.mouse_inertia\
		and inertia_velocity.length() > follower_object.minimal_velocity\
		and last_mouse_velocity < 0.1:
		
		var perpendicular_inertia_velocity: Vector3 =\
												Vector3(-inertia_velocity.z, 0, inertia_velocity.x)
		
		if mouse_move_x > 0:
			inertia_velocity += perpendicular_inertia_velocity / follower_object.perpendicular_weight
		else:
			inertia_velocity -= perpendicular_inertia_velocity / follower_object.perpendicular_weight
			
		vector += inertia_velocity * follower_object.inertia_strenght
		inertia_velocity *= follower_object.inertia_damping
		
		store_mouse_input_position(vector)
		
	return vector

func calculate_inertia_velocity(next_radius_vector: Vector3) -> void:
	if follower_object.mouse_inertia:
		var current_radius_vector: Vector3 = get_rotated_radius_vector(0, 0)
		inertia_velocity = next_radius_vector - current_radius_vector
