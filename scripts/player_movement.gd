extends CharacterBody3D

@export var cameraController : Camera3D
var speed = 5.0
var jumpvelocity = 4.5
var mousesens = 0.2
var tiltlowlimit = deg_to_rad(-90) # kapec := ?
var tiltuplimit = deg_to_rad(90)
var mousedelta : Vector2
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
##############################################################################

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor(): velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor(): velocity.y = jumpvelocity
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	_update_camera(delta)
	rotation.y += -mousedelta.x * delta * mousesens
	
	mousedelta.x = 0 
	mousedelta.y = 0

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
		
# Te nak visi input eventi laikam
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mousedelta.x = event.relative.x
		mousedelta.y = event.relative.y

func _update_camera(delta):
	cameraController.rotation.x -= mousedelta.y * delta * mousesens
	cameraController.rotation.x = clamp(cameraController.rotation.x, tiltlowlimit, tiltuplimit)
