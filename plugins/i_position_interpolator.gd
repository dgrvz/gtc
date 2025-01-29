class_name IPositionInterpolator
extends RefCounted

var weight: float

func _init(w: float) -> void:
	weight = w

func interpolate(current_pos: Vector3, target_pos: Vector3) -> Vector3:
	assert(false, "This class is an interface, do not use it in any other way")
	return current_pos + target_pos / weight
