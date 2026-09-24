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
	
	if orbit: 
		orbit_weight = update_weight
	else:
		orbit_weight = lerpf(orbit_weight, 0, update_weight)
	
	# handle updating the camera
	global_position = lerp(global_position, target.global_position, update_weight)
	
	if orbit_weight:
		var direction := target.global_position - spring_arm.global_position
		direction.y = 0
		
		var target_yaw := atan2(direction.x, direction.z)
		spring_arm.rotation.y = lerp_angle(spring_arm.rotation.y, target_yaw, orbit_weight)
	
	if global_position == target.global_position:
		forward_weight = 0
		orbit_weight = 0
	
	print("ORBIT WEIGHT: " + str(orbit_weight))
	print("POSITION " + str(global_position) + "TARGET " + str(target.global_position))
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * sensitivity
		spring_arm.rotation.y -= event.relative.x * sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -deg_to_rad(tilt_limit), deg_to_rad(tilt_limit))
