extends Node3D

# NOTE
# target should implement direction field (type -> Vector3(x, y, z))
# x, y, z should be in range from 0 to 1, but it not necessarily

@export var target: Node3D
@export var camera_settings: Resource
@export var inertia_settings: Resource

var angles_handler: AnglesHandler
var vector_handler: VectorHandler
var mouse_cache: MouseCache
var _position_interpolator: IPositionInterpolator
var _rotation_interpolator: IRotationInterpolator
var _inertia_processor: InertiaProcessor

func _ready() -> void:
	assert(target != null, "Choose target node in settings")
	assert(target.direction != null, "Target node should implement 'direction' field")
	
	setup_dependencies()
	
	mouse_cache = MouseCache.new(
		camera_settings.horizontal_mouse_sensitivity,
		camera_settings.vertical_mouse_sensitivity
	)
	
	angles_handler = AnglesHandler.new(
		camera_settings.unlock_horizontal_position_axis,
		camera_settings.min_vertical_angle,
		camera_settings.max_vertical_angle,
		mouse_cache
	)
	
	vector_handler = VectorHandler.new(target, $".", _inertia_processor, mouse_cache)
	
	setup_default_position()
	
	add_child(angles_handler)
	add_child(mouse_cache)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and camera_settings.follow_mode != VectorHandler.FollowMode.DIRECTION_MODE\
	and (camera_settings.without_key or Input.is_action_pressed(camera_settings.capture_key)):
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		var desired_position_vector: Vector3 = angles_handler.rotated_radius_vector
		
		_inertia_processor.calculate_inertia_velocity(position, desired_position_vector)

		position = _position_interpolator.interpolate(
			position,
			desired_position_vector,
			camera_settings.position_coefficient * camera_settings.mouse_position_coefficient
		)
		
		basis = _rotation_interpolator.basis_interpolate(
			basis,
			target.global_transform.origin - global_transform.origin,
			camera_settings.rotation_coefficient * camera_settings.mouse_rotation_coefficient
		)

func _physics_process(delta: float) -> void:
	# NOTE
	# always off interpolation in _physics_process when press on (capture_key)
	# even when (without_key = true)
	if target and not Input.is_action_pressed(camera_settings.capture_key):
		if not camera_settings.without_key:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		var desired_position_vector: Vector3 = vector_handler.get_position_from_direction()
		var p_coefficient: float = 60 * delta * camera_settings.position_coefficient * camera_settings.keys_position_coefficient
		var r_coefficient: float = 60 * delta * camera_settings.rotation_coefficient * camera_settings.keys_rotation_coefficient
		
		desired_position_vector = _inertia_processor.apply_inertion(
			desired_position_vector,
			Callable(mouse_cache, "save_mouse_input_position")
		)
		
		position = _position_interpolator.interpolate(
			position,
			desired_position_vector,
			p_coefficient
		)
		
		basis = _rotation_interpolator.basis_interpolate(
			basis,
			target.global_transform.origin - global_transform.origin,
			r_coefficient
		)

func setup_default_position() -> void:
	position.z = camera_settings.distance
	position.y = camera_settings.height_offset
	mouse_cache.last_mouse_input_camera_position = position
	
	if is_instance_of(
		_rotation_interpolator,
		RotationInterpolatorFactory.RotationInterpolatorType.LOOK_AT
	):
		rotation.x = camera_settings.horizontal_default_rotation
	else:
		look_at(target.global_position)

func setup_dependencies() -> void:
	_position_interpolator =\
	PositionInterpolatorFactory.create(camera_settings.position_interpolator_type)
	_rotation_interpolator =\
	RotationInterpolatorFactory.create(camera_settings.rotation_interpolator_type)
	_inertia_processor = InertiaProcessor.new(inertia_settings)
