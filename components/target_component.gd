class_name TargetComponent
extends Object

var target: Node3D

func _init(node: Node3D) -> void:
	target = node

func get_position() -> Vector3:
	return target.position

func set_position(pos: Vector3) -> void:
	target.position = pos

func get_rotation() -> Vector3:
	return target.rotation

func set_rotation(rot: Vector3) -> void:
	target.rotation = rot

func get_basis() -> Basis:
	return target.basis

func set_basis(b: Basis) -> void:
	target.basis = b
