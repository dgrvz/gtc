class_name EntityWrapper
extends RefCounted

var entity: Node3D

func _init(node: Node3D) -> void:
	entity = node

func get_position() -> Vector3:
	return entity.position

func set_position(pos: Vector3) -> void:
	entity.position = pos

func get_global_position() -> Vector3:
	return entity.global_position

func set_global_position(pos: Vector3) -> void:
	entity.global_position  = pos

func get_rotation() -> Vector3:
	return entity.rotation

func set_rotation(rot: Vector3) -> void:
	entity.rotation = rot

func get_basis() -> Basis:
	return entity.basis

func set_basis(b: Basis) -> void:
	entity.basis = b

func get_direction() -> Vector3:
	return entity.direction

func set_direction(d: Vector3) -> void:
	entity.direction = d
