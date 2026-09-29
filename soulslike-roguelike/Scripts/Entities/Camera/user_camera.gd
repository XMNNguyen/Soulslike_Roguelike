extends BaseCamera
class_name UserCamera


@onready var pivot : Node3D = $Pivot
@onready var spring_arm : SpringArm3D = $SpringArm3D
@onready var camera : Camera3D = $SpringArm3D/Camera3D

@export var sensitivity : float = 0.01
@export var tilt_limit : float = 70.0

@export var follow_speed : float = 5.0
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
	free_move(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * sensitivity
		spring_arm.rotation.y -= event.relative.x * sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -deg_to_rad(tilt_limit), deg_to_rad(tilt_limit))
	else:
		spring_arm.look_at(pivot.global_position)


func get_camera() -> Camera3D:
	return camera


func free_move(delta: float) -> void:
	if target == null:
		return
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	if input_dir.y:
		spring_arm.global_position = pivot.global_position
	
	pivot.global_position = lerp(pivot.global_position, target.global_position, 0.5)
	# always have camera look at the target
	camera.look_at(target.global_position)
