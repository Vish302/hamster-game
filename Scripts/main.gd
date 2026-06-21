extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var center_pos = get_viewport().get_visible_rect().size / 2
	Input.warp_mouse(center_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
