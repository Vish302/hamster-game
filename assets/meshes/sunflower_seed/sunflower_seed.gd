extends Node3D

@export var bounce_height_min: float = 0.5
@export var bounce_height_max: float = 1.5
@export var bounce_speed_min: float = 1.0
@export var bounce_speed_max: float = 3.0
@export var spin_speed_min: float = 90.0
@export var spin_speed_max: float = 270.0


var bounce_height: float
var bounce_speed: float
var spin_speed: float
var origin_y: float
var bounce_offset: float  # add this variable

func _ready() -> void:
	origin_y = position.y
	bounce_height = randf_range(bounce_height_min, bounce_height_max)
	bounce_speed  = randf_range(bounce_speed_min,  bounce_speed_max)
	spin_speed    = randf_range(spin_speed_min,    spin_speed_max)
	bounce_offset = randf_range(0.0, TAU)  # TAU = 2*PI, full circle of phase

func _process(delta: float) -> void:
	position.y = origin_y + abs(sin(Time.get_ticks_msec() / 1000.0 * bounce_speed + bounce_offset)) * bounce_height
	rotate_y(deg_to_rad(spin_speed) * delta)
