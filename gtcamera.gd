class_name GTCamera
extends Node3D

var _camera_settings: CameraSettings
var _inertia_settings: InertiaSettings
var _mouse_settings: MouseSettings

var _position_interpolator: IPositionInterpolator
var _rotation_interpolator: IRotationInterpolator
var _inertia_processor: IInertiaProcessor
var _transform_component: EntityWrapper
var _target_component: EntityWrapper
var _mouse_input_handler: IMouseInputHandler
var _target_direction_handler: IVectorInputHandler
var _state: IState

func _init(
	camera_settings: CameraSettings,
	inertia_settings: InertiaSettings,
	mouse_settings: MouseSettings
	) -> void:
	
	_camera_settings = camera_settings
	_inertia_settings = inertia_settings
	_mouse_settings = mouse_settings
	

func get_camera_settings() -> CameraSettings:
	return _camera_settings

func set_camera_settings(c_s: CameraSettings) -> void:
	_camera_settings = c_s

func get_inertia_settings() -> InertiaSettings:
	return _inertia_settings

func set_inertia_settings(i_s: InertiaSettings) -> void:
	_inertia_settings = i_s

func get_mouse_settings() -> MouseSettings:
	return _mouse_settings

func set_mouse_settings(m_s: MouseSettings) -> void:
	_mouse_settings = m_s

func get_position_interpolator() -> IPositionInterpolator:
	return _position_interpolator

func set_position_interpolator(p_i: IPositionInterpolator) -> void:
	_position_interpolator = p_i

func get_rotation_interpolator() -> IRotationInterpolator:
	return _rotation_interpolator

func set_rotation_interpolator(r_i: IRotationInterpolator) -> void:
	_rotation_interpolator = r_i

func get_inertia_processor() -> IInertiaProcessor:
	return _inertia_processor

func set_inertia_processor(i_p: IInertiaProcessor) -> void:
	_inertia_processor = i_p

func get_transform_component() -> EntityWrapper:
	return _transform_component

func set_transform_component(t_c: EntityWrapper) -> void:
	_transform_component = t_c

func get_target_component() -> EntityWrapper:
	return _target_component

func set_target_component(t_c: EntityWrapper) -> void:
	_target_component = t_c

func get_mouse_input_handler() -> IMouseInputHandler:
	return _mouse_input_handler

func set_mouse_input_handler(m_i_h: IMouseInputHandler) -> void:
	_mouse_input_handler = m_i_h

func get_target_direction_handler() -> IVectorInputHandler:
	return _target_direction_handler

func set_target_direction_handler(t_d_i: IVectorInputHandler) -> void:
	_target_direction_handler = t_d_i

func get_state():
	return _state

func set_state(s: IState):
	_state = s
	#_state.exit()
	#_state = s
	#_state.enter()
