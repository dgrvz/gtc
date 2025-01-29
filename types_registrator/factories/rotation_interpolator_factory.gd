class_name RotationInterpolatorFactory
extends IFactory

static var _registry = {}

static func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

static func create(type_id: String) -> IRotationInterpolator:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call()

static func setup_builtins() -> void:
	register("look_at", LookAtRotationInterpolator.new)
	register("linear", LinearRotationInterpolator.new)
	register("bezier", BezierRotationInterpolator.new)
