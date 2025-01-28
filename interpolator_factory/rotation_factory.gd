class_name RotationInterpolatorFactory
extends Object

enum RotationInterpolatorType {LOOK_AT, LINEAR, BEZIER}

static func create(type: RotationInterpolatorType) -> IRotationInterpolator:
	match type:
		RotationInterpolatorType.LOOK_AT:
			return LookAtRotationInterpolator.new()
		RotationInterpolatorType.LINEAR:
			return LinearRotationInterpolator.new()
		RotationInterpolatorType.BEZIER:
			return BezierRotationInterpolator.new()
		_:
			return LookAtRotationInterpolator.new()
