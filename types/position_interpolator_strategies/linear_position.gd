class_name LinearPositionInterpolator
extends IPositionInterpolator

func interpolate(current_pos: Vector3, target_pos: Vector3, weight: float, ) -> Vector3:
	return _linear_type_vector3(current_pos, target_pos, weight)

func _linear_type_vector3(start: Vector3, end: Vector3, weight: float) -> Vector3:
	return start.lerp(end, weight)
