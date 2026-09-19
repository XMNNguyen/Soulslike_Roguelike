extends BaseLevel
class_name DebugLevel

@onready var player_spawn : Marker3D = $PlayerSpawn


func get_player_spawn() -> Vector3:
	return player_spawn.global_position


func get_player_camera() -> Camera3D:
	return
