extends Control

@export var player_stats: Stats

@onready var heart_empty: TextureRect = $heart_empty
@onready var heart_full: TextureRect = $heart_full

func _ready() -> void:
	player_stats.health_change.connect(set_full_hearts)
	set_empty_hearts(player_stats.max_health)
	set_full_hearts(player_stats.health)

func set_empty_hearts(value: int) -> void:
	heart_empty.size.x = value * 15
	
func set_full_hearts(value: int) -> void:
	heart_full.size.x = value * 15	
