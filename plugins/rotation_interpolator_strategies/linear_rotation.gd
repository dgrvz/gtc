class_name LinearRotationInterpolator
extends IRotationInterpolator

func one_axis_interpolate(current_angle: float, target_angle: float) -> float:
	return _linear_type_float(current_angle, target_angle)

func basis_interpolate(
	current_basis: Basis,
	global_position_from_current_to_target: Vector3,
	) -> Basis:
	
	var basis_looking_at_target: Basis = Basis.looking_at(global_position_from_current_to_target)
	var new_basis = Basis(current_basis)
	
	for v: int in range(3):
		new_basis[v] = _linear_type_vector3(current_basis[v], basis_looking_at_target[v])
	
	return new_basis

func _linear_type_float(start: float, end: float) -> float:
	return lerp_angle(start, end, weight)

func _linear_type_vector3(start: Vector3, end: Vector3) -> Vector3:
	return start.lerp(end, weight)
