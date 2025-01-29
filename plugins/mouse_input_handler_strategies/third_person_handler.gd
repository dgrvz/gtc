class_name ThirdPersonHandler
extends IMouseInputHandler

var mouse_move_x: float = 0.0
var mouse_move_y: float = 0.0
var target: TargetComponent

func handle_mouse_input(event: InputEvent) -> void:
	mouse_move_x = clamp(event.screen_relative.x, -100, 100) * mouse_settings.horizontal_sensitivity
	mouse_move_y = clamp(event.screen_relative.y, -100, 100) * mouse_settings.vertical_sensitivity

func get_transformed(transform: TransformComponent) -> Vector3:
	var position = transform.get_position()
	var radius = 25#(target.get_position() - position).length()
	return Trigonometry.move_spherical_radius_vector(
		position,
		radius,
		mouse_move_x,
		mouse_move_y
	)

func transform(
	transform: TransformComponent,
	position_interpolator: IPositionInterpolator,
	rotation_interpolator: IRotationInterpolator,
	) -> void:
	
	var new_position: Vector3 = get_transformed(transform)
	transform.set_position(
		position_interpolator.interpolate(
			transform.get_position(),
			new_position
		)
	)
	transform.set_basis(
		rotation_interpolator.basis_interpolate(
			transform.get_basis(),
			target.get_position() - transform.get_position()
		)
	)

func set_target(t: TargetComponent) -> ThirdPersonHandler:
	target = t
	return self
