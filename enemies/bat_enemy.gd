extends CharacterBody2D

const SPEED = 30.0
const RANGE = 108
const FRICTION = 480

@onready var bat: Sprite2D = $bat
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var enemy_hurt_box: HurtBox = $EnemyHurtBox

func _ready() -> void:
	# call AFTER ALL events finished in the frame
	enemy_hurt_box.hurt.connect(take_hit.call_deferred)

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	
	match state:
		"idle":
			pass
		"chase":
			var player = get_player()
			velocity = global_position.direction_to(player.global_position) * SPEED if player is Player else Vector2.ZERO
			bat.scale.x = sign(velocity.x)
			move_and_slide()
		"hit":
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			move_and_slide()

func take_hit(other_hitbox: HitBox) -> void:
	velocity = other_hitbox.hit_direction * other_hitbox.hit_amount
	playback.start("hit")

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var player = get_player()
	
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		return distance_to_player < RANGE
	
	return false		

func can_see_player() -> bool:	
	if not is_player_in_range():
		return false
		
	var player = get_player()
	ray_cast.target_position = player.global_position - global_position
	# player is in sight, without any collision shapes
	return not ray_cast.is_colliding()
