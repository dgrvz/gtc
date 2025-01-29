class_name Trigonometry
extends Object

static func move_circle_radius_vector(
	position_on_circle: Vector2,
	radius: float,
	radians: float
	) -> Vector2:
	
	var phi: float = atan2(position_on_circle.x, position_on_circle.y)
	var x: float = radius * sin(phi - radians)
	var y: float = radius * cos(phi - radians)
	
	return Vector2(x, y)

static func move_spherical_radius_vector(
	position_on_sphere: Vector3,
	radius: float,
	horizontal_radians: float,
	vertical_radians: float
	) -> Vector3:
	
	var theta: float = acos(position_on_sphere.y / radius)
	
	var h_moved: Vector2 = move_circle_radius_vector(
		Vector2(position_on_sphere.x, position_on_sphere.z),
		radius,
		horizontal_radians
	)
	
	var x: float = h_moved.x * sin(theta + vertical_radians)
	var y: float = radius * cos(theta - vertical_radians)
	var z: float = h_moved.y * sin(theta + vertical_radians)
	
	return Vector3(x, y, z)
