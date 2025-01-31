class_name IState
extends Object

var GTC: GTCamera

func _init(gtc: GTCamera) -> void:
	GTC = gtc

func input_update(event) -> void:
	assert(false, "This class is an interface, do not use it in any other way")

func physics_update(delta) -> void:
	assert(false, "This class is an interface, do not use it in any other way")
