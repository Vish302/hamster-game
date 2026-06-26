extends CharacterBody3D
signal hit

# defining how fast the player falls in mph
@export var fall_acceleration = 75
@export var move_acceleration = 10
@export var stop_acceleration = 6

# jump impulse applied to the character
@export var jump_impulse = 20
@export var move_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO
var moving = false
var wait_for_sound = 0
var alive = true

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)

func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("squeak"):
		$Squeak.play()
	var roll = randi_range(1, 500)
	if roll == 1 and velocity.length() == 0.0:
		$Pivot/C_hamster/AnimationPlayer.play("idle_looped")

# defining the actual movement based on input
func _physics_process(delta: float) -> void:
	# create a local direction
	var direction = Vector3.ZERO
	
	# check for each input and change direction accordingly
	if alive:
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
		if $Pivot/C_hamster/AnimationPlayer.current_animation == "idle_looped":
			$Pivot/C_hamster/AnimationPlayer.stop()
	
	if velocity.length() > 0.5:
		if velocity.length() > 1 and is_on_floor():
			if(wait_for_sound == 10):
				$tippytaps.pitch_scale = randi_range(100, 150)*0.01
				$tippytaps.play()
				wait_for_sound = 0
			else:
				wait_for_sound += 1
		if !moving and !$Pivot/C_hamster/AnimationPlayer.is_playing():
			$Pivot/C_hamster/AnimationPlayer.play("Walk_Cycle_start")
			moving = true
		elif !$Pivot/C_hamster/AnimationPlayer.is_playing():
			$Pivot/C_hamster/AnimationPlayer.play("Walk_Cycle_looped")
	else:
		if moving:
			$Pivot/C_hamster/AnimationPlayer.play("Walk_Cycle_end")
			moving = false
	
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
	
	if is_on_floor() and Input.is_action_pressed("jump") and alive:
		target_velocity.y = jump_impulse
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	velocity = target_velocity
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	die()
	
	
func die():
	hit.emit()
	target_velocity = Vector3.ZERO	
	moving = false
	alive = false
	await get_tree().create_timer(1.0).timeout
	moving = true
	alive = true
	target_velocity.y = jump_impulse
	alive = false
	moving = false
