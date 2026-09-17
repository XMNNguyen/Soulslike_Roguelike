extends Node
class_name Main

# -----------------------------------
# Main Game Script:
# This is the main entry point for this game. It is responsible for setting up and coordinating
# any high level systems within the game. It is also responsible for managing the World layers
# -----------------------------------

# NOTE: Add any level data here as well
const DEBUG_LEVEL : String = "NOTE: MAKE A LEVEL AND PUT UID HERE"
const player_uid : String = "uid://l82p60spqam2"

# -----------------------------------
# WORLD ROOT NODES
# -----------------------------------

@onready var level_root : Node3D = $World/LevelLayer
@onready var entity_root : Node3D = $World/EntityLayer
@onready var effects_root : Node3D = $World/EffectsLayer

# -----------------------------------
# UI ROOT NODES
# -----------------------------------

@onready var hud_root : Node3D = $HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# TODO:
# Add the init player method where we
# 1. Safely take player uid and instantiate as a scene
# 2. Add player to entity layer
# 3. Send player to player spawn point after level loads
func _init_player() -> void:
	pass
	
# TODO:
# Add the load level method where we
# 1. Unload previous level (if needed)
# 2. Instantiate level scene safely
# 3. Add level to level root
# 4. 
func _load_level(level_scene : String) -> void:
	pass
