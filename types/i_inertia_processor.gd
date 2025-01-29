class_name IInertiaProcessor
extends RefCounted

var inertia_velocity: Vector3 = Vector3.ZERO
var inertia_settings: InertiaSettings

func _init(i_s: InertiaSettings) -> void:
	inertia_settings = i_s

func apply_inertion(vector: Vector3) -> Vector3:
	assert(false, "This class is an interface, do not use it in any other way")
	return Vector3.ZERO

func calculate_inertia_velocity(current_position: Vector3, next_position: Vector3) -> void:
	assert(false, "This class is an interface, do not use it in any other way")

func is_inertia() -> bool:
	assert(false, "This class is an interface, do not use it in any other way")
	return false
