extends CharacterBody2D

const SPEED = 30.0
const RANGE = 96

@onready var bat: Sprite2D = $bat
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

func _physics_process(_delta: float) -> void:
	var state = playback.get_current_node()
	
	match state:
		"idle":
			pass
		"chase":
			var player = get_player()
			velocity = global_position.direction_to(player.global_position) * SPEED if player is Player else Vector2.ZERO
			bat.scale.x = sign(velocity.x)
			move_and_slide()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var player = get_player()
	
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		return distance_to_player < RANGE
	
	return false		
