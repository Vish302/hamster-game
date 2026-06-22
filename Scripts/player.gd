extends CharacterBody3D

signal dead

# defining how fast the player falls in mph
@export var fall_acceleration = 75
@export var move_acceleration = 15
@export var stop_acceleration = 7

# jump impulse applied to the character
@export var jump_impulse = 20
@export var move_impulse = 18
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

# defining the actual movement based on input
func _physics_process(delta: float) -> void:
	# create a local direction
	var direction = Vector3.ZERO
	
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
		# basis affects rotation
		$Pivot.basis = Basis.looking_at(direction)
	
	# ground velocity
	target_velocity.x = move_toward(target_velocity.x, move_impulse * direction.x, move_acceleration * delta)
	target_velocity.z = move_toward(target_velocity.z, move_impulse * direction.z, move_acceleration * delta)
	
	if direction.x == 0:
		target_velocity.x = move_toward(velocity.x, 0, stop_acceleration * delta)
	if direction.z == 0:
		target_velocity.z = move_toward(velocity.z, 0, stop_acceleration * delta)

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
