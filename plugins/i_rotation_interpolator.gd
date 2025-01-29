class_name IRotationInterpolator
extends RefCounted

var weight: float

func _init(w: float) -> void:
	weight = w

func one_axis_interpolate(current_angle: float, target_angle: float) -> float:
	assert(false, "This class is an interface, do not use it in any other way")
	return current_angle + target_angle + weight

func basis_interpolate(
	current_basis: Basis,
	global_position_from_current_to_target: Vector3
	) -> Basis:
	
	assert(false, "This class is an interface, do not use it in any other way")
	return Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO)
