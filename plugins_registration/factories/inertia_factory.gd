class_name InertiaFactory
extends IFactory

static var _registry = {}
static var inertia_settings: InertiaSettings

func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

func create(type_id: String) -> IInertiaProcessor:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call(inertia_settings)

static func set_settings(i_s: InertiaSettings) -> InertiaFactory:
	inertia_settings = i_s
	return InertiaFactory.new()
