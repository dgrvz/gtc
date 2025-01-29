class_name LookAtRotationInterpolator
extends IRotationInterpolator

func one_axis_interpolate(current_angle: float, target_angle: float, weight: float) -> float:
	assert(false, "Look at mode not support one axis rotate interpolation")
	return current_angle + target_angle + weight

func basis_interpolate(
	current_basis: Basis,
	global_position_from_current_to_target: Vector3,
	weight: float
	) -> Basis:
	
	return Basis.looking_at(global_position_from_current_to_target)
