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
			follower_object.position = follower_object.position.lerp(position_vector, weight)
		
		MoveInterpolationMode.BEZIER_INTERPOLATE:
			setup_bezier_controls(follower_object.position, position_vector)
			follower_object.position =\
						follower_object.position.bezier_interpolate(
																		control_1,
																		control_2,
																		position_vector,
																		weight
																	)

func interpolate_rotation(weight: float) -> void:
	match rotation_interpolation_mode:
		RotationInterpolationMode.LOOK_AT:
			follower_object.look_at(target_object.global_position)
			
		RotationInterpolationMode.LINEAR_INTERPOLATE:
			if unlock_horizontal_rotation_axis:
				var direction_and_distance: Vector3 =\
					target_object.global_transform.origin - follower_object.global_transform.origin
				var b: Basis = get_basis_looking_at(direction_and_distance)
				for v in range(3):
					follower_object.basis[v] = follower_object.basis.x.lerp(b[v], weight)
			else:
				follower_object.rotation.y =\
									lerp_angle(
													follower_object.rotation.y,
													point_to_radians(
																		follower_object.position.x,
																		follower_object.position.z
																	),
													weight
												)
		
		RotationInterpolationMode.BEZIER_INTERPOLATE:
			if unlock_horizontal_rotation_axis:
				var direction_and_distance: Vector3 =\
					target_object.global_transform.origin - follower_object.global_transform.origin
				var b: Basis = get_basis_looking_at(direction_and_distance)
				
				for v in range(3):
					setup_bezier_controls(b[v], follower_object.global_transform.basis[v])
					follower_object.basis[v] =\
										follower_object.basis[v].bezier_interpolate(
																						control_1,
																						control_2,
																						b[v],
																						weight
																					)
			else:
				var desired_rotation = point_to_radians(
															follower_object.position.x,
															follower_object.position.z
														)
				
				# WARNING
				# fix "camera panic" when trigonometric circle moves from PI to -PI and vice versa
				if (follower_object.rotation.y < -0.7 and 0.7 < desired_rotation):
					follower_object.rotation.y =\
											lerp_angle(
															PI + (PI + follower_object.rotation.y),
															desired_rotation,
															weight
														)
				elif (desired_rotation < -0.7 and 0.7 < follower_object.rotation.y):
					follower_object.rotation.y =\
											lerp_angle(
															-PI + (-PI + follower_object.rotation.y),
															desired_rotation,
															weight
														)
				
				setup_bezier_controls(follower_object.rotation.y, desired_rotation)
				follower_object.rotation.y = bezier_interpolate(
																	follower_object.rotation.y,
																	control_1,
																	control_2,
																	desired_rotation,
																	weight
																)

func get_basis_looking_at(pos: Vector3) -> Basis:
	var forward: Vector3 = pos
	var v_z: Vector3 = -forward.normalized()
	var v_x: Vector3 = Vector3.UP.cross(v_z)
	var v_y: Vector3 = v_z.cross(v_x.normalized())
	
	return Basis(v_x, v_y, v_z)

func setup_bezier_controls(start, end) -> void:
	control_1 = start + 0.1 * (end - start)
	control_2 = end - 0.9 * (end - start)

static func point_to_radians(x: float, y: float) -> float:
	return atan2(x, y)
