class_name VectorInputHandlerFactory
extends IFactory

static var _registry = {}

func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

func create(type_id: String) -> IVectorInputHandler:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call()
