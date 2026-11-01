extends Node2D

const GRASS_EFFECT = preload("res://effects/grass_effect.tscn")

@onready var grass_hurt_box: HurtBox = $GrassHurtBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_2d.area_entered.connect(_on_area_2d_area_entered)
	grass_hurt_box.hurt.connect(_on_hurt)

func _on_hurt(_other_hitbox: HitBox) -> void:
	var grass_effect_instance = GRASS_EFFECT.instantiate()
	get_tree().current_scene.add_child(grass_effect_instance)
	grass_effect_instance.global_position = global_position
	queue_free()
