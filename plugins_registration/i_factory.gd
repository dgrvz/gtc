class_name IFactory
extends Object

func register(type_id: String, constructor: Callable) -> void:
	assert(false, "This class is an interface, do not use it in any other way")

func create(type_id: String) -> Variant:
	assert(false, "This class is an interface, do not use it in any other way")
	return
