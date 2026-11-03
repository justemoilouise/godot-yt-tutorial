class_name Stats extends Resource

@export var health := 1 :
	set(value):
		var previous_health = health
		health = value
		
		if health <= 0: no_health.emit()
		if (health != previous_health): health_change.emit(health)
	
@export var max_health := 1

signal no_health()

signal health_change(value: int)
