extends Node
class_name Main

# -----------------------------------
# Main Game Script:
# This is the main entry point for this game. It is responsible for setting up and coordinating
# any high level systems within the game. It is also responsible for managing the World layers
# -----------------------------------

# NOTE: Add any level data here as well
const DEBUG_LEVEL : String = "uid://dwu1qbbbpr0ui"
const PLAYER_UID : String = "uid://l82p60spqam2"

var player : Player = null
var current_level : BaseLevel = null

# -----------------------------------
# WORLD ROOT NODES
# -----------------------------------

@onready var level_root : Node3D = $World/LevelLayer
@onready var entity_root : Node3D = $World/EntityLayer
@onready var effects_root : Node3D = $World/EffectsLayer

# -----------------------------------
# UI ROOT NODES
# -----------------------------------

@onready var hud_root : CanvasLayer = $HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_player()
	_load_level(DEBUG_LEVEL)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Helper method to load the player scene safely
func _init_player() -> void:
	# Load player scene
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_UID) as PackedScene
	if player_scene == null:
		push_error("COULD NOT LOAD PLAYER SCENE: " + PLAYER_UID)
		return
	
	# Instantiate player
	player = player_scene.instantiate() as Player
	if player == null:
		push_error("PLAYER SCENE N/A OR COULD NOT INSTANTIATE")
		return
	
	entity_root.add_child(player)
	

# Helper method to safely load level
func _load_level(level_scene : String) -> void:
	_defered_load_level.call_deferred(level_scene)


func _defered_load_level(level_uid : String) -> void:
	# unload previous level
	if current_level != null:
		current_level.queue_free()
		current_level = null
		
	await get_tree().process_frame
	
	# load and instantiate the level scene
	var level_scene : PackedScene = ResourceLoader.load(level_uid) as PackedScene
	if level_scene == null:
		push_error("COULD NOT LOAD LEVEL SCENE " + level_uid)
		return
	
	current_level = level_scene.instantiate() as BaseLevel
	if current_level == null:
		push_error("LEVEL SCENE N/A OR COULD NOT INSTANTIATE")
		return
	
	level_root.add_child(current_level)
	
	# make sure to let level load before accessing it
	# place player and camera in correct possitions
	await get_tree().process_frame
	place_player_at_spawn()
	attach_camera_to_player()


func place_player_at_spawn() -> void:
	if player == null:
		push_error("CAN NOT PLACE PLAYER, DOES NOT EXIST")
		return
	
	if current_level == null:
		push_error("CAN NOT ACCESS LEVEL, LEVEL DOES NOT EXIST")
		return
	
	player.global_position = current_level.get_player_spawn()


func attach_camera_to_player() -> void:
	if current_level == null:
		push_error("CAN NOT ATTACH CAMERA, LEVEL NOT LOADED")
		return
	
	if player == null:
		push_error("CAN NOT ATTACH CAMERA, PLAYER NOT LOADED")
	
	if current_level.get_player_camera() == null:
		push_error("CAMERA DOES NOT EXIST")
		return
	
	current_level.assign_camera(player.head_pos)
	player.cur_camera =  current_level.get_player_camera()
