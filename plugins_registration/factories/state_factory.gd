class_name StateFactory
extends IFactory

static var _registry = {}
static var GTC: GTCamera

func register(type_id: String, constructor: Callable) -> void:
	_registry[type_id] = constructor

func create(type_id: String) -> IState:
	var constructor: Callable = _registry.get(type_id)
	return constructor.call(GTC)

static func set_gtc(gtc: GTCamera) -> StateFactory:
	GTC = gtc
	return StateFactory.new()
