class_name HurtBox extends Area2D

signal hurt(hitbox: HitBox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area2d: Area2D) -> void:
	if area2d is not HitBox: return
	hurt.emit(area2d)
