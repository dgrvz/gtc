extends Camera3D

@export var camera_settings: CameraSettings
@export var inertia_settings: InertiaSettings
@export var mouse_settings: MouseSettings

var camera: GTCamera

func _ready() -> void:
	camera = GTCBuilder.new(camera_settings, inertia_settings, mouse_settings).set_transform_component(
		EntityWrapper.new($".")
	).set_target_component(
		EntityWrapper.new($"..")
	).set_inertia_processor(
		"spiral"
	).set_mouse_input_handler(
		"spherical_handler"
	).set_position_interpolator(
		"bezier"
	).set_rotation_interpolator(
		"bezier"
	).set_state(
		"third_person_camera"
	).set_target_direction_handler(
		"third_person_follower"
	).build()

func _unhandled_input(event: InputEvent) -> void:
	camera.get_state().input_update(event)

func _physics_process(delta: float) -> void:
	camera.get_state().physics_update(delta)
