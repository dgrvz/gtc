class_name LinearPositionInterpolator
extends IPositionInterpolator

func interpolate(current_pos: Vector3, target_pos: Vector3) -> Vector3:
	return _linear_type_vector3(current_pos, target_pos)

func _linear_type_vector3(start: Vector3, end: Vector3) -> Vector3:
	return start.lerp(end, weight)
