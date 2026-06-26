extends Node3D
@export var spin_speed_min: float = 90.0
@export var spin_speed_max: float = 270.0

var spin_speed: float
var origin_y: float

func _ready() -> void:
	origin_y = position.y
	spin_speed    = randf_range(spin_speed_min,    spin_speed_max)

func _process(delta: float) -> void:
	position.y = origin_y + abs(sin(Time.get_ticks_msec() / 1000.0 ))
	rotate_y(deg_to_rad(spin_speed) * delta)
