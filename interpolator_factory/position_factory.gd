class_name PositionInterpolatorFactory
extends Object

enum PositionInterpolatorType {LINEAR, BEZIER}

static func create(type: PositionInterpolatorType) -> IPositionInterpolator:
	match type:
		PositionInterpolatorType.LINEAR:
			return LinearPositionInterpolator.new()
		PositionInterpolatorType.BEZIER:
			return BezierPositionInterpolator.new()
		_:
			return LinearPositionInterpolator.new()
