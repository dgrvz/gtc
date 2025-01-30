class_name IVectorInputHandler
extends RefCounted

func get_transformed(transform: TransformComponent) -> Vector3:
	assert(false, "This class is an interface, do not use it in any other way")
	return Vector3.ZERO

func transform(
	transform: TransformComponent,
	position_interpolator: IPositionInterpolator,
	rotation_interpolator: IRotationInterpolator
	) -> void:
	assert(false, "This class is an interface, do not use it in any other way")
