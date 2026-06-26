extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the WorldEnvironment node
	var env = $WorldEnvironment.environment

	var sky_mat = env.sky.sky_material as ProceduralSkyMaterial
	sky_mat.sky_top_color = Color(0.1, 0.3, 0.9)
	sky_mat.sky_horizon_color = Color(0.6, 0.8, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
