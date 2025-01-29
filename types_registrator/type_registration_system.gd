class_name TypeRegistrationSystem
extends Object

static var types = {}

static func initialize_types() -> void:
	register_type("inertia_factory", InertiaFactory)
	register_type("position_interpolator_factory", PositionInterpolatorFactory)
	register_type("rotation_interpolator_factory", RotationInterpolatorFactory)
	
	for type in types.values():
		type.setup_builtins()

static func register_type(type_id: String, factory: Object) -> void:
	types[type_id] = factory

static func get_type(type_id: String) -> IFactory:
	return types.get(type_id)
