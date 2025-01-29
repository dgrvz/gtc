class_name CameraSettings
extends Resource

@export_group("Mode")
@export var rotation_interpolator_type: String = "linear"
@export var position_interpolator_type: String = "linear"
@export var inertia_processor_type: String = "spiral"
@export var follow_mode: VectorHandler.FollowMode
@export var main_remembered_position: VectorHandler.MainRememberedPosition # works only with BOTH follow mode

@export_subgroup("Horizontal axis")
@export var unlock_horizontal_position_axis: bool = false
@export var unlock_horizontal_rotation_axis: bool = false
@export var min_vertical_angle: float = 3.0
@export var max_vertical_angle: float = 14.0

@export_subgroup("Key control")
@export var without_key: bool = true
@export var capture_key: String = "Mouse_1"

@export_group("Interpolate coefficients")
@export var change_position_trigger: float = 0.62
@export var rotation_coefficient: float = 1.0 # not work with LOOK_AT mode
@export var position_coefficient: float = 1.0

@export_subgroup("From mouse")
@export var mouse_rotation_coefficient: float = 1.0 # not work with LOOK_AT mode
@export var mouse_position_coefficient: float = 1.0

@export_subgroup("From direction")
@export var keys_rotation_coefficient: float = 1.0 # not work with LOOK_AT mode
@export var keys_position_coefficient: float = 1.0

@export_group("Default position")
@export var distance: float = 25.0
@export var height_offset: float = 10.0
@export var horizontal_default_rotation: float = -0.5 # not work with LOOK_AT mode and when (unlock_horizontal_rotation_axis = true)
