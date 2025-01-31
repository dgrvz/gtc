extends Camera3D

var camera: GTCamera

func _ready() -> void:
	camera = GTCBuilder.new().set_transform_component(
		TransformComponent.new($".")
	).set_target_component(
		TargetComponent.new($"..")
	).set_inertia_processor(
		"null"
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
