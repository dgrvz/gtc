class_name BezierRotationInterpolator
extends IRotationInterpolator

var control_1: Variant
var control_2: Variant

# WARNING BUG
# fix "camera panic" when trigonometric circle moves from PI to -PI and vice versa
# only for one axis interpolate
func one_axis_interpolate(current_angle: float, target_angle: float) -> float:
	return _bezier_type_float(current_angle, target_angle)

func basis_interpolate(
	current_basis: Basis,
	global_position_from_current_to_target: Vector3
	) -> Basis:
	
	var basis_looking_at_target: Basis = Basis.looking_at(global_position_from_current_to_target)
	var new_basis = Basis(current_basis)
	
	for v: int in range(3):
		new_basis[v] = _bezier_type_vector3(current_basis[v], basis_looking_at_target[v])
	
	return new_basis

func _bezier_type_float(start: float, end: float) -> float:
	_setup_bezier_controls(start, end)
	return bezier_interpolate(start, control_1, control_2, end, weight)

func _bezier_type_vector3(start: Vector3, end: Vector3) -> Vector3:
	_setup_bezier_controls(start, end)
	return start.bezier_interpolate(control_1, control_2, end, weight)

func _setup_bezier_controls(current_angle: Variant, target_angle: Variant) -> void:
	control_1 = current_angle + 0.1 * (target_angle - current_angle)
	control_2 = target_angle - 0.9 * (target_angle - current_angle)
