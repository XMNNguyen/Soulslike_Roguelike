extends BaseCamera
class_name UserCamera


@onready var pivot : Node3D = $Pivot
@onready var spring_arm : SpringArm3D = $Pivot/SpringArm3D
@onready var camera : Camera3D = $Pivot/SpringArm3D/Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
