extends BaseCamera
class_name UserCamera


@onready var pivot : Node3D = $Pivot
@onready var spring_arm : SpringArm3D = $Pivot/SpringArm3D
@onready var camera : Camera3D = $Pivot/SpringArm3D/Camera3D

@export var sensitivity : float = 0.01
@export var tilt_limit : float = 70.0

@export var follow_speed : float = 100.0
@export var look_speed : float = 5.0

var previous_player_position : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if target:
		previous_player_position = target.global_position
		global_position = target.global_position


# Rotate the camera if moving left and right and then lerp camera to player if moving forward and backward
func _physics_process(delta: float) -> void:
	if target == null:
		return

	var player_delta := target.global_position - previous_player_position

	# Direction from camera toward player.
	var to_player := target.global_position - global_position
	
	if to_player.length_squared() > 0.001:
		to_player = to_player.normalized()

		# How much of the player's movement is toward/away
		# from the camera?
		var forward_delta := player_delta.dot(to_player)

		var follow_weight := 1.0 - exp(-follow_speed * delta)

		# Only move the camera along the camera -> player axis.
		global_position += to_player * forward_delta * follow_weight

	# Update previous position AFTER calculating movement.
	previous_player_position = target.global_position

	# Always face the player.
	var look_direction := target.global_position - camera.global_position

	if look_direction.length_squared() > 0.001:
		var desired_rotation := Basis.looking_at(
			look_direction.normalized(),
			Vector3.UP
		)

		camera.global_transform.basis = camera.global_transform.basis.slerp(
			desired_rotation,
			1.0 - exp(-look_speed * delta)
		)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * sensitivity
		spring_arm.rotation.y -= event.relative.x * sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -deg_to_rad(tilt_limit), deg_to_rad(tilt_limit))
