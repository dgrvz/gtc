class_name InertiaFactory
extends Object

enum InertiaProcessorType {NULL, SPIRAL}

static func create(type: InertiaProcessorType, i_s: InertiaSettings) -> IInertiaProcessor:
	match type:
		InertiaProcessorType.NULL:
			return NullInertiaProcessor.new(i_s)
		InertiaProcessorType.SPIRAL:
			return SpiralInertiaProcessor.new(i_s)
		_:
			return NullInertiaProcessor.new(i_s)
