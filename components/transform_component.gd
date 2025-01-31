class_name TransformComponent
extends Object

var camera: Node3D

func _init(node: Node3D) -> void:
	camera = node

func get_position() -> Vector3:
	return camera.position

func set_position(pos: Vector3) -> void:
	camera.position = pos

func get_global_position() -> Vector3:
	return camera.global_position

func set_global_position(pos: Vector3) -> void:
	camera.global_position  = pos

func get_rotation() -> Vector3:
	return camera.rotation

func set_rotation(rot: Vector3) -> void:
	camera.rotation = rot

func get_basis() -> Basis:
	return camera.basis

func set_basis(b: Basis) -> void:
	camera.basis = b
