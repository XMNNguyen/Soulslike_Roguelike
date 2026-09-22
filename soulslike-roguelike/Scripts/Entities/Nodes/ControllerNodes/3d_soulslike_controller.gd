extends ControllerNode
class_name JumpController


@export var JUMP_VELOCITY = 4.5
@export var target : CharacterBody3D = null


func run(delta : float) -> void:
	if target == null:
		push_error("CAN NOT RUN JUMP CONTROLLER, TARGET DNE")
		return
	
		# Add the gravity.
	if not target.is_on_floor():
		target.velocity += target.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("dodge") and target.is_on_floor():
		target.velocity.y = JUMP_VELOCITY
