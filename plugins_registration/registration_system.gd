class_name RegistrationSystem
extends RefCounted

static var types = {}

func register_factory(type_id: String, factory: IFactory) -> void:
	types[type_id] = factory

func get_factory(type_id: String) -> IFactory:
	return types.get(type_id)

func initialize_builtin_types() -> void:
	register_factory("inertia_factory", InertiaFactory.new())
	register_factory("position_interpolator_factory", PositionInterpolatorFactory.new())
	register_factory("rotation_interpolator_factory", RotationInterpolatorFactory.new())
	register_factory("mouse_input_handler_factory", MouseInputHandlerFactory.new())
	register_factory("vector_input_handler_factory", VectorInputHandlerFactory.new())
	register_factory("state_factory", StateFactory.new())
	
	_register_inertia_implementations()
	_register_position_interpolator_implementations()
	_register_rotation_interpolator_implementations()
	_register_mouse_input_handler_implementations()
	_register_vector_input_handler_implementations()
	_register_state_implementations()

func _register_inertia_implementations() -> void:
	get_factory("inertia_factory").register("null", NullInertiaProcessor.new)
	get_factory("inertia_factory").register("spiral", SpiralInertiaProcessor.new)

func _register_position_interpolator_implementations() -> void:
	get_factory("position_interpolator_factory").register("linear", LinearPositionInterpolator.new)
	get_factory("position_interpolator_factory").register("bezier", BezierPositionInterpolator.new)

func _register_rotation_interpolator_implementations() -> void:
	get_factory("rotation_interpolator_factory").register("look_at", LookAtRotationInterpolator.new)
	get_factory("rotation_interpolator_factory").register("linear", LinearRotationInterpolator.new)
	get_factory("rotation_interpolator_factory").register("bezier", BezierRotationInterpolator.new)

func _register_mouse_input_handler_implementations() -> void:
	get_factory("mouse_input_handler_factory").register("spherical_handler", SphericalHandler.new)

func _register_vector_input_handler_implementations() -> void:
	get_factory("vector_input_handler_factory").register("third_person_follower", ThirdPersonFollower.new)

func _register_state_implementations() -> void:
	get_factory("state_factory").register("third_person_camera", ThirdPersonCameraState.new)
