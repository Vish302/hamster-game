extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOver/Screen.hide()
	Global.win = false
	Global.alive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _on_player_hit() -> void:
	pass
	await get_tree().create_timer(2.3).timeout
	$GameOver/Screen.show()		


func _on_player_sunflower_win() -> void:
	$WinJingle.play()
	Global.alive = false
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/win.tscn")
	
