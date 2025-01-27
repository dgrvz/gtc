extends Object
class_name MouseCache

var last_mouse_input_camera_position: Vector3 = Vector3.BACK
var mouse_move_x: float = 0.0
var mouse_move_y: float = 0.0
var horizontal_mouse_sensitivity: float
var vertical_mouse_sensitivity: float

func _init(h_sens: float, v_sens: float) -> void:
	horizontal_mouse_sensitivity = h_sens
	vertical_mouse_sensitivity = v_sens

func save_mouse_velocity(event: InputEvent) -> void:
	mouse_move_x = clamp(event.screen_relative.x, -100, 100) * horizontal_mouse_sensitivity
	mouse_move_y = clamp(event.screen_relative.y, -100, 100) * vertical_mouse_sensitivity

func store_mouse_input_position(pos: Vector3) -> void:
	last_mouse_input_camera_position = pos
