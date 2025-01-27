extends Object
class_name InterpolationManager

enum RotationInterpolationMode {LOOK_AT, LINEAR_INTERPOLATE, BEZIER_INTERPOLATE}
enum MoveInterpolationMode {LINEAR_INTERPOLATE, BEZIER_INTERPOLATE}

var rotation_interpolation_mode: RotationInterpolationMode
var move_interpolation_mode: MoveInterpolationMode
var target_object: Node3D
var follower_object: Node3D
var unlock_horizontal_rotation_axis: bool

var control_1
var control_2

func _init(
				t_o: Node3D,
				f_o: Node3D,
				r_mode: RotationInterpolationMode,
				m_mode: MoveInterpolationMode,
				h_axis: bool
		) -> void:
	
	target_object = t_o
	follower_object = f_o
	rotation_interpolation_mode = r_mode
	move_interpolation_mode = m_mode
	unlock_horizontal_rotation_axis = h_axis

func interpolate_position(position_vector: Vector3, weight: float) -> void:
	match move_interpolation_mode:
		MoveInterpolationMode.LINEAR_INTERPOLATE:
			follower_object.position = linear(weight, follower_object.position, position_vector)
		
		MoveInterpolationMode.BEZIER_INTERPOLATE:
			follower_object.position = bezier(weight, follower_object.position, position_vector)

func interpolate_rotation(weight: float) -> void:
	match rotation_interpolation_mode:
		RotationInterpolationMode.LOOK_AT:
			follower_object.look_at(target_object.global_position)
			
		RotationInterpolationMode.LINEAR_INTERPOLATE:
			if unlock_horizontal_rotation_axis:
				all_axis_rotation("linear", weight)
			else:
				follower_object.rotation.y = linear(weight, follower_object.rotation.y)
		
		RotationInterpolationMode.BEZIER_INTERPOLATE:
			if unlock_horizontal_rotation_axis:
				all_axis_rotation("bezier", weight)
			else:
				var radians = get_current_radians()
				
				# WARNING
				# fix "camera panic" when trigonometric circle moves from PI to -PI and vice versa
				if (follower_object.rotation.y < -0.7 and 0.7 < radians):
					follower_object.rotation.y =\
											linear(weight, PI + (PI + follower_object.rotation.y))
				elif (radians < -0.7 and 0.7 < follower_object.rotation.y):
					follower_object.rotation.y =\
											linear(weight, -PI + (-PI + follower_object.rotation.y))
				
				follower_object.rotation.y = bezier(weight, follower_object.rotation.y, radians)

func all_axis_rotation(function, weight) -> void:
	var b: Basis = get_basis_looking_at_target()
	for v in range(3):
		follower_object.basis[v] = call(function, weight, follower_object.basis[v], b[v])

func linear(weight, start, end = Vector3.ZERO):
	if is_instance_of(start, TYPE_FLOAT):
		return lerp_angle(start, get_current_radians(), weight)
	elif is_instance_of(start, TYPE_VECTOR3):
		return start.lerp(end, weight)

func bezier(weight, start, end):
	setup_bezier_controls(start, end)
	if is_instance_of(start, TYPE_FLOAT):
		return bezier_interpolate(start, control_1, control_2, end, weight)
	elif is_instance_of(start, TYPE_VECTOR3):
		return start.bezier_interpolate(control_1, control_2, end, weight)

func get_basis_looking_at_target() -> Basis:
	var forward: Vector3 =\
					target_object.global_transform.origin - follower_object.global_transform.origin
	var v_z: Vector3 = -forward.normalized()
	var v_x: Vector3 = Vector3.UP.cross(v_z)
	var v_y: Vector3 = v_z.cross(v_x.normalized())
	
	return Basis(v_x, v_y, v_z)

func setup_bezier_controls(start, end) -> void:
	control_1 = start + 0.1 * (end - start)
	control_2 = end - 0.9 * (end - start)

func get_current_radians() -> float:
	return point_to_radians(follower_object.position.x, follower_object.position.z)

static func point_to_radians(x: float, y: float) -> float:
	return atan2(x, y)
