class_name SphericalHandler
extends IMouseInputHandler

var mouse_move_x: float = 0.0
var mouse_move_y: float = 0.0
var target: EntityWrapper
var radius: float

func handle_mouse_input(event: InputEvent) -> void:
	mouse_move_x = clamp(event.screen_relative.x, -100, 100) * mouse_settings.horizontal_sensitivity
	mouse_move_y = clamp(event.screen_relative.y, -100, 100) * mouse_settings.vertical_sensitivity

func get_transformed(transform: EntityWrapper) -> Vector3:
	var position = transform.get_position()
	mouse_move_x = lerp(mouse_move_x, 0.0, mouse_settings.move_damping)
	mouse_move_y = lerp(mouse_move_y, 0.0, mouse_settings.move_damping)
	return Trigonometry.move_spherical_radius_vector(
		position,
		radius,
		mouse_move_x,
		mouse_move_y
	)

func transform(
	transform: EntityWrapper,
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

func set_target(t: EntityWrapper) -> SphericalHandler:
	target = t
	return self

func set_radius(r: float) -> SphericalHandler:
	radius = r
	return self
