class_name ThirdPersonFollower
extends IVectorInputHandler

var target: TargetComponent
var trigger: float
var radius: float
var height_offset: float

func get_transformed(transform: TransformComponent) -> Vector3:
	if not _direction_in_range():
			
		return Vector3(
			-target.get_direction().x * radius,
			height_offset,
			-target.get_direction().z * radius
		)
	
	elif _direction_in_range():
		return transform.get_position()
	else:
		return transform.get_position()

func transform(
	transform: TransformComponent,
	position_interpolator: IPositionInterpolator,
	rotation_interpolator: IRotationInterpolator,
	inertia_processor: IInertiaProcessor
	) -> void:
	
	var new_position: Vector3 = get_transformed(transform)
	new_position = inertia_processor.apply_inertion(new_position)
	transform.set_position(
		position_interpolator.interpolate(
			transform.get_position(),
			new_position
		)
	)
	transform.set_basis(
		rotation_interpolator.basis_interpolate(
			transform.get_basis(),
			target.get_global_position() - transform.get_global_position()
		)
	)

func _direction_in_range() -> bool:
	return abs(target.get_direction().x) < trigger\
	and abs(target.get_direction().y) < trigger\
	and abs(target.get_direction().z) < trigger

func set_target(t: TargetComponent) -> ThirdPersonFollower:
	target = t
	return self
	
func set_trigger(t: float) -> ThirdPersonFollower:
	trigger = t
	return self

func set_radius(r: float) -> ThirdPersonFollower:
	radius = r
	return self

func set_height_offset(h: float) -> ThirdPersonFollower:
	height_offset = h
	return self
