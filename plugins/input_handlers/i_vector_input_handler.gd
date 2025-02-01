class_name IVectorInputHandler
extends RefCounted

func get_transformed(transform: EntityWrapper) -> Vector3:
	assert(false, "This class is an interface, do not use it in any other way")
	return Vector3.ZERO

func transform(
	transform: EntityWrapper,
	position_interpolator: IPositionInterpolator,
	rotation_interpolator: IRotationInterpolator,
	inertia_processor: IInertiaProcessor
	) -> void:
	assert(false, "This class is an interface, do not use it in any other way")
