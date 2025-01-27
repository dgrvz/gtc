extends Node3D

# NOTE
# target should implement direction field (type -> Vector3(x, y, z))
# x, y, z should be in range from 0 to 1, but it not necessarily

@export var target: Node3D
@export var horizontal_mouse_sensitivity: float = 0.001
@export var vertical_mouse_sensitivity: float = 0.001

@export_group("Mode")
@export var rotation_interpolation_mode: InterpolationManager.RotationInterpolationMode
@export var move_interpolation_mode: InterpolationManager.MoveInterpolationMode
@export var follow_mode: DirectionHandler.FollowMode
@export var main_remembered_position: DirectionHandler.MainRememberedPosition # works only with BOTH follow mode

@export_subgroup("Horizontal axis")
@export var unlock_horizontal_position_axis: bool = false
@export var unlock_horizontal_rotation_axis: bool = false
@export var min_vertical_angle: float = 3.0
@export var max_vertical_angle: float = 14.0

@export_subgroup("Key control")
@export var without_key: bool = true
@export var capture_key: String = "Mouse_1"

@export_group("Interpolate coefficients")
@export var change_position_trigger: float = 0.62
@export var rotation_coefficient: float = 1.0 # not work with LOOK_AT mode
@export var position_coefficient: float = 1.0

@export_subgroup("From mouse")
@export var mouse_rotation_coefficient: float = 1.0 # not work with LOOK_AT mode
@export var mouse_position_coefficient: float = 1.0

@export_subgroup("From direction")
@export var keys_rotation_coefficient: float = 1.0 # not work with LOOK_AT mode
@export var keys_position_coefficient: float = 1.0

@export_group("Mouse inertia")
@export var mouse_inertia: bool = true
@export var inertia_damping: float = 0.8
@export var inertia_strenght: float = 0.8
@export var perpendicular_weight: float = 8.0
@export var minimal_velocity: float = 0.1 # for effect should be less than (save_userinput_position_while_inertia), but not necessarily
@export var save_userinput_position_while_inertia: float = 0.1

@export_group("Main position")
@export var distance: float = 25.0
@export var height_offset: float = 10.0
@export var horizontal_default_rotation: float = -0.5 # not work with LOOK_AT mode and when (unlock_horizontal_position_axis = true)

var interpolator: InterpolationManager
var mouse_handler: MouseHandler
var direction_handler: DirectionHandler
var configurator: Configurator

func _ready() -> void:
	assert(target != null, "Choose target node in settings")
	assert(target.direction != null, "Target node should implement 'direction' field")
	
	interpolator = InterpolationManager.new(
		target,
		$".",
		rotation_interpolation_mode,
		move_interpolation_mode,
		unlock_horizontal_rotation_axis
	)
	
	mouse_handler = MouseHandler.new(
		target,
		$".",
		horizontal_mouse_sensitivity,
		vertical_mouse_sensitivity
	)
	
	direction_handler = DirectionHandler.new(
		target,
		$".",
		mouse_handler
	)
	
	configurator = Configurator.new(
		target,
		$".",
		mouse_handler,
		direction_handler,
		interpolator
	)
	
	configurator.setup_default_position()
	configurator.configure_follow_mode()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and follow_mode != DirectionHandler.FollowMode.DIRECTION_MODE\
	and (without_key or Input.is_action_pressed(capture_key)):
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_handler.store_mouse_input_position(position)
		mouse_handler.save_mouse_velocity(event)
		
		var desired_position_vector: Vector3 = mouse_handler.get_rotated_radius_vector(
			mouse_handler.mouse_move_x,
			mouse_handler.mouse_move_y
		)
														
		mouse_handler.calculate_inertia_velocity(desired_position_vector)
		interpolator.interpolate_position(
			desired_position_vector,
			position_coefficient * mouse_position_coefficient
		)
		interpolator.interpolate_rotation(rotation_coefficient * mouse_rotation_coefficient)

func _physics_process(delta: float) -> void:
	# NOTE
	# always off interpolation in _physics_process when press on (capture_key)
	# even when (without_key = true)
	if target and not Input.is_action_pressed(capture_key):
		if not without_key:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		var desired_position_vector: Vector3 = direction_handler.get_position_from_direction()
		var p_coefficient: float = 60 * delta * position_coefficient * keys_position_coefficient
		var r_coefficient: float = 60 * delta * rotation_coefficient * keys_rotation_coefficient
		
		mouse_handler.delay_before_inertion(0.99)
		desired_position_vector = mouse_handler.apply_mouse_inertion(desired_position_vector)
		interpolator.interpolate_position(desired_position_vector, p_coefficient)
		interpolator.interpolate_rotation(r_coefficient)
