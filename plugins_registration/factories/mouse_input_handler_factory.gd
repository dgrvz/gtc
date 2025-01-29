class_name MouseInputHandlerFactory
extends IFactory

static var _registry = {}
static var mouse_settings: MouseSettings

func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

func create(type_id: String) -> IMouseInputHandler:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call(mouse_settings)

static func set_settings(m_s: MouseSettings) -> MouseInputHandlerFactory:
	mouse_settings = m_s
	return MouseInputHandlerFactory.new()
