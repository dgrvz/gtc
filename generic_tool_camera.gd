class_name GenericToolCamera
extends Node3D

# NOTE
# target should implement direction field (type -> Vector3(x, y, z))
# x, y, z should be in range from 0 to 1, but it not necessarily

@export var target: Node3D
@export var camera_settings: CameraSettings
@export var inertia_settings: InertiaSettings
@export var mouse_settings: MouseSettings
var DIContainer: RegistrationSystem

var _position_interpolator: IPositionInterpolator
var _rotation_interpolator: IRotationInterpolator
var _inertia_processor: IInertiaProcessor
var _transform_component: TransformComponent
var _target_component: TargetComponent
var _mouse_input_handler: IMouseInputHandler
var _target_direction_handler: IVectorInputHandler

func _ready() -> void:
	assert(target != null, "Choose target node in settings")
	assert(target.direction != null, "Target node should implement 'direction' field")
	
	DIContainer = RegistrationSystem.new()
	setup_dependencies(DIContainer)
	setup_default_position()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion\
	and (camera_settings.without_key or Input.is_action_pressed(camera_settings.capture_key)):
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		_mouse_input_handler.handle_mouse_input(event)
		var desired_position_vector: Vector3 = _mouse_input_handler.get_transformed(_transform_component)
		
		_inertia_processor.calculate_inertia_velocity(position, desired_position_vector)

		position = _position_interpolator.interpolate(
			position,
			desired_position_vector
		)
		
		basis = _rotation_interpolator.basis_interpolate(
			basis,
			target.global_transform.origin - global_transform.origin
		)

func _physics_process(delta: float) -> void:
	# NOTE
	# always off interpolation in _physics_process when press on (capture_key)
	# even when (without_key = true)
	if target and not Input.is_action_pressed(camera_settings.capture_key):
		if not camera_settings.without_key:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		var desired_position_vector: Vector3 = _target_direction_handler.get_transformed(_transform_component)
			
		desired_position_vector = _inertia_processor.apply_inertion(desired_position_vector)
		
		position = _position_interpolator.interpolate(
			position,
			desired_position_vector
		)
		
		basis = _rotation_interpolator.basis_interpolate(
			basis,
			target.global_transform.origin - global_transform.origin
		)

func setup_default_position() -> void:
	position.z = camera_settings.distance
	position.y = camera_settings.height_offset
	
	if not is_instance_of(
		_rotation_interpolator,
		LookAtRotationInterpolator
	):
		rotation.x = camera_settings.horizontal_default_rotation
	else:
		look_at(target.global_position)

func setup_dependencies(DIContainer: RegistrationSystem) -> void:
	_transform_component = TransformComponent.new($".")
	_target_component = TargetComponent.new(target)
	
	DIContainer.initialize_builtin_types()
	
	_position_interpolator = DIContainer.get_factory(
		"position_interpolator_factory"
	).set_weight(
		camera_settings.position_coefficient
	).create(camera_settings.position_interpolator_type)

	_rotation_interpolator = DIContainer.get_factory(
		"rotation_interpolator_factory"
	).set_weight(
		camera_settings.rotation_coefficient
	).create(camera_settings.rotation_interpolator_type)

	_inertia_processor = DIContainer.get_factory(
		"inertia_factory"
	).set_settings(inertia_settings).create(camera_settings.inertia_processor_type)
	
	_mouse_input_handler = DIContainer.get_factory(
		"mouse_input_handler_factory"
	).set_settings(mouse_settings).create(
		"spherical_handler"
	).set_target(_target_component).set_radius(camera_settings.distance)
	
	_target_direction_handler = DIContainer.get_factory(
		"vector_input_handler_factory"
	).create(
		"third_person_follower"
	).set_target(_target_component)\
	.set_radius(camera_settings.distance)\
	.set_trigger(camera_settings.change_position_trigger)\
	.set_height_offset(camera_settings.height_offset)
