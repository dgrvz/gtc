extends Object
class_name InterpolationManager

enum RotationInterpolationMode {LOOK_AT, LINEAR_INTERPOLATE, BEZIER_INTERPOLATE}
enum MoveInterpolationMode {LINEAR_INTERPOLATE, BEZIER_INTERPOLATE}

var rotation_interpolation_mode: RotationInterpolationMode
var move_interpolation_mode: MoveInterpolationMode
var target_object: Node3D
var follower_object: Node3D
var unlock_horizontal_rotation_axis: bool

#bezier controls
var control_1: Variant
var control_2: Variant

func _init(
	r_mode: RotationInterpolationMode,
	m_mode: MoveInterpolationMode,
	h_axis: bool
	) -> void:
	
	rotation_interpolation_mode = r_mode
	move_interpolation_mode = m_mode
	unlock_horizontal_rotation_axis = h_axis

func interpolate_position(position_vector: Vector3, weight: float) -> void:
	match move_interpolation_mode:
		MoveInterpolationMode.LINEAR_INTERPOLATE:
			follower_object.position =\
			interpolate("linear", weight, follower_object.position, position_vector)
		
		MoveInterpolationMode.BEZIER_INTERPOLATE:
			follower_object.position =\
			interpolate("bezier", weight, follower_object.position, position_vector)

func interpolate_rotation(weight: float) -> void:
	match rotation_interpolation_mode:
		RotationInterpolationMode.LOOK_AT:
			follower_object.look_at(target_object.global_position)
			
		RotationInterpolationMode.LINEAR_INTERPOLATE:
			if unlock_horizontal_rotation_axis:
				all_axis_rotate_interpolation("linear", weight)
			else:
				follower_object.rotation.y =\
				interpolate("linear", weight, follower_object.rotation.y, get_current_radians())
		
		RotationInterpolationMode.BEZIER_INTERPOLATE:
			if unlock_horizontal_rotation_axis:
				all_axis_rotate_interpolation("bezier", weight)
			else:
				# WARNING BUG
				# fix "camera panic" when trigonometric circle moves from PI to -PI and vice versa
				if (follower_object.rotation.y < -0.7 and 0.7 < get_current_radians()):
					follower_object.rotation.y =\
					interpolate(
						"linear",
						weight*0.5,
						PI + (PI + follower_object.rotation.y),
						get_current_radians()
					)
				elif (get_current_radians() < -0.7 and 0.7 < follower_object.rotation.y):
					follower_object.rotation.y =\
					interpolate(
						"linear",
						weight*0.5,
						-PI + (-PI + follower_object.rotation.y),
						get_current_radians()
					)
				
				follower_object.rotation.y =\
				interpolate("bezier", weight, follower_object.rotation.y, get_current_radians())

func all_axis_rotate_interpolation(method: String, weight: float) -> void:
	var b: Basis = _get_basis_looking_at_target()
	for v: int in range(3):
		follower_object.basis[v] = interpolate(method, weight, follower_object.basis[v], b[v])

func interpolate(method: String, weight: float, start: Variant, end: Variant) -> Variant:
	if method == "bezier":
		_setup_bezier_controls(start, end)
	var m: Callable = _get_interpolation_method(method, typeof(start))
	return m.call(weight, start, end)

func _get_interpolation_method(name: String, type: int) -> Callable:
	var methods: Dictionary = {
		"linear": {
			TYPE_FLOAT: _linear_type_float,
			TYPE_VECTOR3: _linear_type_vector3
		},
		"bezier": {
			TYPE_FLOAT: _bezier_type_float,
			TYPE_VECTOR3: _bezier_type_vector3
		}
	}
	return methods.get(name).get(type)

func _linear_type_float(weight: float, start: float, end: float) -> float:
	return lerp_angle(start, end, weight)

func _linear_type_vector3(weight: float, start: Vector3, end: Vector3) -> Vector3:
	return start.lerp(end, weight)

func _bezier_type_float(weight: float, start: float, end: float) -> float:
	return bezier_interpolate(start, control_1, control_2, end, weight)

func _bezier_type_vector3(weight: float, start: Vector3, end: Vector3) -> Vector3:
	return start.bezier_interpolate(control_1, control_2, end, weight)

func _get_basis_looking_at_target() -> Basis:
	var forward: Vector3 =\
	target_object.global_transform.origin - follower_object.global_transform.origin
	
	var v_z: Vector3 = -forward.normalized()
	var v_x: Vector3 = Vector3.UP.cross(v_z)
	var v_y: Vector3 = v_z.cross(v_x.normalized())
	
	return Basis(v_x, v_y, v_z)

func _setup_bezier_controls(start: Variant, end: Variant) -> void:
	control_1 = start + 0.1 * (end - start)
	control_2 = end - 0.9 * (end - start)

func set_target(target: Node3D) -> void:
	target_object = target

func set_follower(follower: Node3D) -> void:
	follower_object = follower

func get_current_radians() -> float:
	return point_to_radians(follower_object.position.x, follower_object.position.z)

static func point_to_radians(x: float, y: float) -> float:
	return atan2(x, y)
