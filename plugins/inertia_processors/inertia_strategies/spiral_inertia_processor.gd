class_name SpiralInertiaProcessor
extends IInertiaProcessor

var inertia_velocity_is_clockwise_direction: bool

func apply_inertion(vector: Vector3) -> Vector3:
	if is_inertia():
		var perpendicular_inertia_velocity = Vector3(-inertia_velocity.z, 0, inertia_velocity.x)
		
		if inertia_velocity_is_clockwise_direction:
			inertia_velocity += perpendicular_inertia_velocity / inertia_settings.perpendicular_weight
		else:
			inertia_velocity -= perpendicular_inertia_velocity / inertia_settings.perpendicular_weight
		vector += inertia_velocity * inertia_settings.inertia_strenght
		inertia_velocity *= inertia_settings.inertia_damping
	
	return vector

func calculate_inertia_velocity(current_position: Vector3, next_position: Vector3) -> void:
	inertia_velocity = next_position - current_position
	# WARNING BUG
	# incorrect perpendicular inertia when trigonometric circle moves from PI to -PI and vice versa
	if atan2(next_position.x, next_position.z) < atan2(current_position.x, current_position.z):
		inertia_velocity_is_clockwise_direction = true
	else:
		inertia_velocity_is_clockwise_direction = false

func is_inertia() -> bool:
	var inertia_is_upper_than_min_inertia_velocity: bool =\
	inertia_velocity.length() > inertia_settings.minimal_inertia_velocity
	
	return inertia_is_upper_than_min_inertia_velocity
