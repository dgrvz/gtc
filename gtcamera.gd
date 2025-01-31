class_name GTCamera
extends Node3D

var _camera_settings: CameraSettings = preload("res://gtc/configs/camera_settings.tres")
var _inertia_settings: InertiaSettings = preload("res://gtc/configs/inertia_settings.tres")
var _mouse_settings: MouseSettings = preload("res://gtc/configs/mouse_settings.tres")

var _position_interpolator: IPositionInterpolator
var _rotation_interpolator: IRotationInterpolator
var _inertia_processor: IInertiaProcessor
var _transform_component: TransformComponent
var _target_component: TargetComponent
var _mouse_input_handler: IMouseInputHandler
var _target_direction_handler: IVectorInputHandler
var _state: IState

func get_state():
	return _state

func set_state():
	pass
