extends Object
class_name AnglesHandler

var target_object: Node3D
var follower_object: Node3D

func _init(t_o: Node3D, f_o: Node3D) -> void:
	target_object = t_o
	follower_object = f_o

func get_rotated_radius_vector(horizontal_radians: float, vertical_radians: float) -> Vector3:
									
	var phi: float =\
	InterpolationManager.point_to_radians(follower_object.position.x, follower_object.position.z)
	
	var theta: float = acos(follower_object.position.y / follower_object.distance)
	
	var x: float = follower_object.distance * sin(phi - horizontal_radians)
	var y: float = follower_object.height_offset
	var z: float = follower_object.distance * cos(phi - horizontal_radians)
	
	if follower_object.unlock_horizontal_position_axis:
		x *= sin(theta + vertical_radians)
		y = clamp(
			follower_object.distance * cos(theta - vertical_radians),
			follower_object.min_vertical_angle,
			follower_object.max_vertical_angle
		)
		z *= sin(theta + vertical_radians)
	
	return Vector3(x, y, z)
