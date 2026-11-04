extends CharacterBody2D

const SPEED = 30.0
const MIN_RANGE = 4
const MAX_RANGE = 108
const FRICTION = 480

const HIT_EFFECT = preload("uid://ds0hh5o8xmp84")
const ENEMY_DEATH_EFFECT = preload("uid://dwdxyc8emevf7")

@onready var bat: Sprite2D = $bat
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var enemy_hurt_box: HurtBox = $EnemyHurtBox
@onready var center: Marker2D = $Center
@onready var marker_2d: Marker2D = $Marker2D
@onready var navigation_agent_2d: NavigationAgent2D = $Marker2D/NavigationAgent2D

@export var stats: Stats

func _ready() -> void:
	# every bat has its own instance
	stats = stats.duplicate()
	
	# call AFTER ALL events finished in the frame
	enemy_hurt_box.hurt.connect(take_hit.call_deferred)
	stats.no_health.connect(enemy_death)

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	
	match state:
		"idle":
			pass
		"chase":
			var player = get_player()
			if player is Player:
				navigation_agent_2d.target_position = player.global_position
				var next_point = navigation_agent_2d.get_next_path_position()
				velocity = global_position.direction_to(next_point - marker_2d.position) * SPEED
			else:
				velocity = Vector2.ZERO
				
			bat.scale.x = sign(velocity.x)
			move_and_slide()
		"hit":
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			move_and_slide()

func take_hit(other_hitbox: HitBox) -> void:
	var hit_effect = HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(hit_effect)
	hit_effect.global_position = center.global_position
	
	stats.health -= other_hitbox.damage
	velocity = other_hitbox.hit_direction * other_hitbox.hit_amount
	playback.start("hit")

func enemy_death() -> void:
	var enemy_death_effect = ENEMY_DEATH_EFFECT.instantiate()
	get_tree().current_scene.add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
	queue_free()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var player = get_player()
	
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		return MIN_RANGE < distance_to_player and distance_to_player < MAX_RANGE
	
	return false		

func can_see_player() -> bool:	
	if not is_player_in_range():
		return false
		
	var player = get_player()
	ray_cast.target_position = player.global_position - global_position
	ray_cast.force_raycast_update()
	
	# player is in sight, without any collision shapes
	return not ray_cast.is_colliding()
