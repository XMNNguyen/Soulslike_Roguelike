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
	global_position = lerp(global_position, target.global_position, update_weight)
	
	var direction := camera.global_position - target.global_position
	direction.y = 0.0

	var orbit := atan2(direction.x, direction.z)
	spring_arm.rotation.y = orbit


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * sensitivity
		spring_arm.rotation.y -= event.relative.x * sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -deg_to_rad(tilt_limit), deg_to_rad(tilt_limit))
