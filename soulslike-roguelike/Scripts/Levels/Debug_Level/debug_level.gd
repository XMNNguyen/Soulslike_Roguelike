extends BaseLevel
class_name DebugLevel

@onready var player_spawn : Marker3D = $PlayerSpawn
@onready var user_camera : BaseCamera = $UserCamera


func get_player_spawn() -> Vector3:
	return player_spawn.global_position


func get_player_camera() -> BaseCamera:
	return user_camera
