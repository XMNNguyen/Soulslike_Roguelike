extends BaseCamera
class_name UserCamera

enum {FREE, MOVE, LOCK}

@onready var pivot : Node3D = $Pivot
@onready var camera : Camera3D = $Camera3D
@onready var follow_point : Node3D = $FollowPoint

@export var sensitivity : float = 0.01
@export var tilt_limit : float = 70.0
@export var camera_offset : float = 5.0
@export var max_idle : float = 2.0

@export var follow_speed : float = 60
@export var look_speed : float = 30.0

var previous_player_position : Vector3
var mouse_move : bool = false
var mouse_idle : float = 0.0
var mode := FREE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if target:
		previous_player_position = target.global_position
		global_position = target.global_position


# Rotate the camera if moving left and right and then lerp camera to player if moving forward and backward
func _physics_process(delta: float) -> void:
	# check for mouse idle time and change mode when idle for too long
	if mouse_move:
		mouse_idle = 0.0
		mode = MOVE
	else:
		mouse_idle += delta
	
	mouse_move = false 
	
	if mouse_idle >= max_idle:
		mode = FREE
		mouse_move = false
	
	# handle different camera modes
	if mode == FREE:
		free_move(delta)
	elif mode == MOVE:
		pass
	else:
		pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_idle = 0.0
		mouse_move = true

func get_camera() -> Camera3D:
	return camera


func free_move(delta: float) -> void:
	if target == null:
		return

	var forward := pivot.global_position - camera.global_position
	forward.y = 0.0

	if forward.length_squared() < 0.001:
		return

	forward = forward.normalized()

	# How much the player moved since the previous frame
	var player_delta := target.global_position - previous_player_position

	# Forward/backward movement
	var forward_distance := player_delta.dot(forward)

	# Vertical movement
	var vertical_distance := player_delta.y

	# Move camera by exactly those two components
	camera.global_position += (
		forward * forward_distance
		+ Vector3.UP * vertical_distance
	)

	pivot.global_position = target.global_position

	camera.look_at(target.global_position)

	previous_player_position = target.global_position
