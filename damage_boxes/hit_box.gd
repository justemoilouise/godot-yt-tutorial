class_name HitBox extends Area2D

@export var damage := 1
@export var hit_direction: Vector2
@export var hit_amount := 200
@export var stores_hit_targets: bool = false

var hit_targets: Array

func clear_hit_targets() -> void:
	hit_targets.clear()
