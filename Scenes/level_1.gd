extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOver/Screen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _on_player_hit() -> void:
	pass
	await get_tree().create_timer(2.3).timeout
	$GameOver/Screen.show()		
