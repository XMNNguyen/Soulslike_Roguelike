extends BaseLevel
class_name DebugLevel

@onready var player_spawn : Marker3D = $PlayerSpawn
@onready var user_camera : BaseCamera = $UserCamera
@onready var debug_camera : Camera3D = $DebugCamera


func _ready() -> void:
	debug_camera.make_current()
	pass

func get_player_spawn() -> Vector3:
	return player_spawn.global_position


func get_player_camera() -> BaseCamera:
	return user_camera


func assign_camera(target : Node3D) -> void:
	user_camera.target = target
	#debug_camera.make_current()
