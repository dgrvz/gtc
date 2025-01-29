class_name PositionInterpolatorFactory
extends IFactory

static var _registry = {}

static func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

static func create(type_id: String) -> IPositionInterpolator:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call()

static func setup_builtins() -> void:
	register("linear", LinearPositionInterpolator.new)
	register("bezier", BezierPositionInterpolator.new)
