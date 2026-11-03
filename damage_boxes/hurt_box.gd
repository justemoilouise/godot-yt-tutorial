class_name HurtBox extends Area2D

signal hurt(hitbox: HitBox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_entered(area2d: Area2D) -> void:
	if area2d is not HitBox: return
	
	var area2d_hitbox = area2d as HitBox
	if self in area2d_hitbox.hit_targets: return
	
	if area2d_hitbox.stores_hit_targets: 	area2d_hitbox.hit_targets.append(self)
	hurt.emit(area2d)
