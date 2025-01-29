class_name BezierPositionInterpolator
extends IPositionInterpolator

var control_1: Vector3
var control_2: Vector3

func interpolate(current_pos: Vector3, target_pos: Vector3) -> Vector3:
	return _bezier_type_vector3(current_pos, target_pos)

func _bezier_type_vector3(start: Vector3, end: Vector3) -> Vector3:
	_setup_bezier_controls(start, end)
	return start.bezier_interpolate(control_1, control_2, end, weight)

func _setup_bezier_controls(current_pos: Vector3, target_pos: Vector3) -> void:
	control_1 = current_pos + 0.1 * (target_pos - current_pos)
	control_2 = target_pos - 0.9 * (target_pos - current_pos)
