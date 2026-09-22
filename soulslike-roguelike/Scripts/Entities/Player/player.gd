extends CharacterBody3D
class_name Player

@onready var head_pos : Marker3D = $HeadPos
@onready var componants : Array = $Componants.get_children()

var cur_camera : BaseCamera = null

func _physics_process(delta: float) -> void:
	# handle all physics and stat based componants here
	# NOTE: all componants must have "run" method
	for componant in componants:
		if componant.has_method("run"):
			componant.run(delta)

	move_and_slide()
