extends CharacterBody3D

# --- Movement ---
const SPEED = 5.0
const AIR_ACCELERATION = 4.0 # How much control the player has in the air.

# --- Mouse Look ---
const MOUSE_SENSITIVITY = 0.002 # Radians per pixel

# --- Jump Physics ---
const JUMP_VELOCITY = 8.0
const JUMP_GRAVITY = 16.0
const FALL_GRAVITY = 22.0
const TERMINAL_VELOCITY = -50.0

@onready var spring_arm = $SpringArm3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Mouse movement and capture/release logic (unchanged)
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			spring_arm.rotate_x(event.relative.y * MOUSE_SENSITIVITY)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-90), deg_to_rad(70))
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed and not event.is_echo():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# --- Vertical Movement (Gravity & Jump) ---
	if not is_on_floor():
		var gravity = JUMP_GRAVITY if velocity.y > 0 else FALL_GRAVITY
		velocity.y -= gravity * delta
		velocity.y = max(velocity.y, TERMINAL_VELOCITY)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- Horizontal Movement (with Momentum) ---
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	# Ground movement (snappy and precise)
	if is_on_floor():
		if direction:
			# Set velocity directly for instant movement
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			# Stop instantly (replicates original friction)
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	# Air movement (preserves momentum)
	else:
		# Gradually change velocity for air control, preserving existing momentum
		velocity.x = move_toward(velocity.x, direction.x * SPEED, AIR_ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, AIR_ACCELERATION * delta)

	move_and_slide()
