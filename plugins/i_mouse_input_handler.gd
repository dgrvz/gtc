class_name IMouseInputHandler
extends RefCounted

var mouse_settings: MouseSettings

func _init(m_s: MouseSettings) -> void:
	mouse_settings = m_s

func handle_mouse_input(event: InputEvent) -> void:
	assert(false, "This class is an interface, do not use it in any other way")

func get_transformed(transform: TransformComponent) -> Vector3:
	assert(false, "This class is an interface, do not use it in any other way")
	return Vector3.ZERO

func transform(
	transform: TransformComponent,
	position_interpolator: IPositionInterpolator,
	rotation_interpolator: IRotationInterpolator
	) -> void:
	assert(false, "This class is an interface, do not use it in any other way")
