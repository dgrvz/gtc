class_name InertiaFactory
extends IFactory

static var _registry = {}
static var inertia_settings: InertiaSettings

static func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

static func create(type_id: String) -> IInertiaProcessor:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call(inertia_settings)

static func setup_builtins() -> void:
	register("null", NullInertiaProcessor.new)
	register("spiral", SpiralInertiaProcessor.new)

static func set_settings(i_s: InertiaSettings) -> Object:
	inertia_settings = i_s
	return InertiaFactory
