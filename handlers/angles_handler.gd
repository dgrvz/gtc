extends Node
class_name AnglesHandler

var unlock_horizontal_position_axis: bool
var min_vertical_angle: float
var max_vertical_angle: float
var angles_generator: MouseCache # ohh.. i can do interfaces like classes, anyway, all this code will be redisigned

var rotated_radius_vector: Vector3

func _init(h_axis: bool, min_v_angle: float, max_v_angle: float, m_cache: MouseCache) -> void:
	unlock_horizontal_position_axis = h_axis
	min_vertical_angle = min_v_angle
	max_vertical_angle = max_v_angle
	angles_generator = m_cache

func calculate_rotated_radius_vector(
	position_on_sphere: Vector3,
	radius: float,
	horizontal_radians: float,
	vertical_radians: float,
	height_offset: float = 0
	) -> Vector3:
	
	var phi: float = atan2(position_on_sphere.x, position_on_sphere.z)
	var theta: float = acos(position_on_sphere.y / radius)
	
	var x: float = radius * sin(phi - horizontal_radians)
	var y: float = height_offset
	var z: float = radius * cos(phi - horizontal_radians)
	
	if unlock_horizontal_position_axis:
		x *= sin(theta + vertical_radians)
		y = clamp(
			radius * cos(theta - vertical_radians),
			min_vertical_angle,
			max_vertical_angle
		)
		z *= sin(theta + vertical_radians)
	
	return Vector3(x, y, z)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var follower_object = get_parent()
		rotated_radius_vector = calculate_rotated_radius_vector(
			follower_object.position,
			follower_object.camera_settings.distance,
			angles_generator.mouse_move_x,
			angles_generator.mouse_move_y,
			follower_object.camera_settings.height_offset
		)
