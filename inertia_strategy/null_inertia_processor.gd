class_name NullInertiaProcessor
extends IInertiaProcessor

func apply_inertion(vector: Vector3) -> Vector3:
	return vector

func calculate_inertia_velocity(current_position: Vector3, next_position: Vector3) -> void:
	pass

func is_inertia() -> bool:
	return false
