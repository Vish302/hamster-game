extends SpringArm3D

@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -85.0 # Limit looking straight down
@export var max_pitch: float = 80.0  # Limit looking straight up

var is_dragging: bool = false

func _ready() -> void:
	# Convert degrees to radians for math operations
	min_pitch = deg_to_rad(min_pitch)
	max_pitch = deg_to_rad(max_pitch)

func _input(event: InputEvent) -> void:
	# Detect when the user clicks and holds the Right Mouse Button
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = event.pressed
			
			# Optional: Hide/Lock mouse cursor while dragging like Roblox
			if is_dragging:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Rotate the camera base only when dragging
	elif event is InputEventMouseMotion and is_dragging:
		# 1. Rotate horizontally (yaw) around the Y-axis
		rotation.y -= event.relative.x * mouse_sensitivity
		
		# 2. Rotate vertically (pitch) around the X-axis
		rotation.x -= event.relative.y * mouse_sensitivity
		
		# 3. Clamp the vertical pitch so the camera doesn't flip upside down
		rotation.x = clamp(rotation.x, min_pitch, max_pitch)
