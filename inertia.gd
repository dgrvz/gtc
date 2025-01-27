extends Object
class_name Inertia

var inertia_velocity: Vector3 = Vector3.ZERO

var follower_object: Node3D
var mouse_cache: MouseCache

func _init(f_o: Node3D, m_cache: MouseCache) -> void:
	follower_object = f_o
	mouse_cache = m_cache

func apply_inertion(vector: Vector3) -> Vector3:
	if follower_object.mouse_inertia and is_inertia():
		
		var perpendicular_inertia_velocity: Vector3 =\
		Vector3(-inertia_velocity.z, 0, inertia_velocity.x)
		
		if mouse_cache.mouse_move_x > 0:
			inertia_velocity += perpendicular_inertia_velocity / follower_object.perpendicular_weight
		else:
			inertia_velocity -= perpendicular_inertia_velocity / follower_object.perpendicular_weight
			
		vector += inertia_velocity * follower_object.inertia_strenght
		inertia_velocity *= follower_object.inertia_damping
		
		mouse_cache.store_mouse_input_position(vector)
		
	return vector

func calculate_inertia_velocity(next_radius_vector: Vector3) -> void:
	if follower_object.mouse_inertia:
		inertia_velocity = next_radius_vector - follower_object.position

func is_inertia() -> bool:
	var inertia_is_upper_than_min_inertia_velocity: bool =\
	inertia_velocity.length() > follower_object.minimal_inertia_velocity
	
	return inertia_is_upper_than_min_inertia_velocity
