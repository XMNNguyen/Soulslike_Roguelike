extends BaseCamera
class_name UserCamera


@onready var pivot : Node3D = $Pivot
@onready var spring_arm : SpringArm3D = $Pivot/SpringArm3D
@onready var camera : Camera3D = $Pivot/SpringArm3D/Camera3D

@export var sensitivity : float = 0.01
@export var tilt_limit : float = 70
@export var update_weight : float = 0.03


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Rotate the camera if moving left and right and then lerp camera to player if moving forward and backward
func _physics_process(delta: float) -> void:
	if target == null:
		return 
	
	# handle updating the camera
	if (camera.global_position.distance_to(target.global_position) > spring_arm.spring_length ||
		camera.global_position.distance_to(target.global_position) < spring_arm.spring_length - 1):
		global_position = global_position.lerp(target.global_position, update_weight)
	
	camera.look_at(target.global_position)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * sensitivity
		spring_arm.rotation.y -= event.relative.x * sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -deg_to_rad(tilt_limit), deg_to_rad(tilt_limit))
