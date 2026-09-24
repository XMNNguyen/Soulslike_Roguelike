extends BaseCamera
class_name UserCamera


@onready var pivot : Node3D = $Pivot
@onready var spring_arm : SpringArm3D = $Pivot/SpringArm3D
@onready var camera : Camera3D = $Pivot/SpringArm3D/Camera3D

@export var sensitivity : float = 0.01
@export var tilt_limit : float = 70
@export var update_weight : float = 0.03

var orbit_weight : float = 0
var forward_weight : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Rotate the camera if moving left and right and then lerp camera to player if moving forward and backward
func _physics_process(delta: float) -> void:
	if target == null:
		return 
	
	# get input axis for orbit directions and forward movement directions and check them
	var orbit := Input.get_axis("left", "right")
	var forward := Input.get_axis("forward", "backward")
	
	if forward: 
		forward_weight = update_weight
		
	if orbit: 
		orbit_weight = update_weight
	
	# handle updating the camera
	if forward_weight:
		global_position = lerp(global_position, target.global_position, forward_weight)
	
	if orbit_weight:
		var target_rotation := global_transform.looking_at(target.global_position, Vector3.UP)
		spring_arm.basis = spring_arm.basis.slerp(target_rotation.basis, orbit_weight)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * sensitivity
		spring_arm.rotation.y -= event.relative.x * sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -deg_to_rad(tilt_limit), deg_to_rad(tilt_limit))
