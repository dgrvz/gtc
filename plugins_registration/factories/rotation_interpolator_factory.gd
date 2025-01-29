class_name RotationInterpolatorFactory
extends IFactory

static var _registry = {}
static var weight: float

func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

func create(type_id: String) -> IRotationInterpolator:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call(weight)

func set_weight(w: float) -> RotationInterpolatorFactory:
	weight = w
	return RotationInterpolatorFactory.new()
