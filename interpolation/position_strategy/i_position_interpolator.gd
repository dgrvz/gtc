class_name IPositionInterpolator
extends Object

func interpolate(current_pos: Vector3, target_pos: Vector3, weight: float) -> Vector3:
	assert(false, "This class is an interface, do not use it in any other way")
	return current_pos + target_pos / weight
