extends Node

@onready var pause: AudioStreamPlayer2D = $pause
@onready var unpause: AudioStreamPlayer2D = $unpause

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var is_paused = get_tree().paused
		
		if is_paused:
			unpause.play()
		else:
			pause.play()
		
		get_tree().paused = not is_paused
