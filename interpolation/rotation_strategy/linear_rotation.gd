class_name LinearRotationInterpolator
extends IRotationInterpolator

func one_axis_interpolate(current_angle: float, target_angle: float, weight: float) -> float:
	return _linear_type_float(current_angle, target_angle, weight)

func basis_interpolate(
	current_basis: Basis,
	global_position_from_current_to_target: Vector3,
	weight: float
	) -> Basis:
	
	var basis_looking_at_target: Basis =\
	current_basis.looking_at(global_position_from_current_to_target)
	
	for v: int in range(3):
		current_basis[v] = _linear_type_vector3(current_basis[v], basis_looking_at_target[v], weight)
	
	return current_basis

func _linear_type_float(start: float, end: float, weight: float) -> float:
	return lerp_angle(start, end, weight)

func _linear_type_vector3(start: Vector3, end: Vector3, weight: float) -> Vector3:
	return start.lerp(end, weight)
