class_name GTCBuilder
extends RefCounted

var _camera_settings: CameraSettings
var _inertia_settings: InertiaSettings
var _mouse_settings: MouseSettings

var _gtcamera: GTCamera
var _dicontainer: RegistrationSystem

func _init(
	camera_settings: CameraSettings,
	inertia_settings: InertiaSettings,
	mouse_settings: MouseSettings
	) -> void:
	
	_camera_settings = camera_settings
	_inertia_settings = inertia_settings
	_mouse_settings = mouse_settings
	
	_gtcamera = GTCamera.new(camera_settings, inertia_settings, mouse_settings)
	_dicontainer = RegistrationSystem.new()
	_dicontainer.initialize_builtin_types()

func set_position_interpolator(p_i: String) -> GTCBuilder:
	_gtcamera.set_position_interpolator(_dicontainer.get_factory(
		"position_interpolator_factory"
	).set_weight(
		_camera_settings.position_coefficient
	).create(p_i))
	return self

func set_rotation_interpolator(r_i: String) -> GTCBuilder:
	_gtcamera.set_rotation_interpolator(_dicontainer.get_factory(
		"rotation_interpolator_factory"
	).set_weight(
		_camera_settings.rotation_coefficient
	).create(r_i))
	return self

func set_inertia_processor(i_p: String) -> GTCBuilder:
	_gtcamera.set_inertia_processor(_dicontainer.get_factory(
		"inertia_factory"
	).set_settings(_inertia_settings).create(i_p))
	return self

func set_transform_component(t_c: EntityWrapper) -> GTCBuilder:
	_gtcamera.set_transform_component(t_c)
	return self

func set_target_component(t_c: EntityWrapper) -> GTCBuilder:
	_gtcamera.set_target_component(t_c)
	return self

func set_mouse_input_handler(m_i_h: String) -> GTCBuilder:
	_gtcamera.set_mouse_input_handler(_dicontainer.get_factory(
		"mouse_input_handler_factory"
	).set_settings(_mouse_settings).create(
		m_i_h
	).set_target(_gtcamera._target_component).set_radius(_camera_settings.distance))
	return self

func set_target_direction_handler(t_d_h: String) -> GTCBuilder:
	_gtcamera.set_target_direction_handler(_dicontainer.get_factory(
		"vector_input_handler_factory"
	).create(
		t_d_h
	).set_target(_gtcamera._target_component)\
	.set_radius(_camera_settings.distance)\
	.set_trigger(_camera_settings.change_position_trigger)\
	.set_height_offset(_camera_settings.height_offset))
	return self

func set_state(s: String) -> GTCBuilder:
	_gtcamera._state = _dicontainer.get_factory(
		"state_factory"
	).set_gtc(_gtcamera).create(s)
	return self

func build() -> GTCamera:
	return _gtcamera
