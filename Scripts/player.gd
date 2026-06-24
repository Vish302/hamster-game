extends CharacterBody3D

signal dead

# defining how fast the player falls in mph
@export var fall_acceleration = 75
@export var move_acceleration = 15
@export var stop_acceleration = 4

# jump impulse applied to the character
@export var jump_impulse = 20
@export var move_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

@export var _camera : Camera3D
@export var _camera_pivot : Node3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)

func _process(delta: float) -> void:	
	if Input.is_action_just_pressed("squeak"):
		$AudioStreamPlayer.play()

# defining the actual movement based on input
func _physics_process(delta: float) -> void:
	# create a local direction
	var direction = Vector3.ZERO
	var forward = $Pivot.transform.basis.z.normalized()
	
	# check for each input and change direction accordingly
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	# if the player inputted something we will change the rotation to it
	if direction != Vector3.ZERO:
		# diagonal might be a little longer than single axis movement
		direction = direction.normalized()
	
	# This combines forward/backward and left/right inputs together
	var move_dir = ($Pivot.transform.basis.z * direction.z) + ($Pivot.transform.basis.x * direction.x)
	if move_dir != Vector3.ZERO:
		move_dir = move_dir.normalized()

	# Separate horizontal target from gravity
	var target_ground = move_dir * move_impulse
	var current_ground = Vector3(target_velocity.x, 0, target_velocity.z)
	
	# Determine if the player is actively pressing keys or stopping
	var current_accel = move_acceleration if direction != Vector3.ZERO else stop_acceleration
	
	# Smoothly move toward the target velocity in 3D space
	current_ground = current_ground.move_toward(target_ground, current_accel * delta)
	
	# Apply the calculated speeds back to the actual velocity tracker
	target_velocity.x = current_ground.x
	target_velocity.z = current_ground.z

	# vertical velocity 
	if not is_on_floor(): # basically emulating gravity here
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	else:
		target_velocity.y = 0
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	velocity = target_velocity
	move_and_slide()

#func _unhandled_input(event: InputEvent) -> void:
	# Mouselook implemented using `screen_relative` for resolution-independent sensitivity.
	#if event is InputEventMouseMotion:
		#_camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		#_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		#_camera_pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity
