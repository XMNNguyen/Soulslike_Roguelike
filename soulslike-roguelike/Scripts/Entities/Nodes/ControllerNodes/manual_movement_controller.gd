extends ControllerNode
class_name InputMovementController

@export var SPEED : float = 4.5
@export var TURN_WEIGHT : float = 0.1
@export var target : CharacterBody3D = null


func run(delta : float) -> void:
	if target == null:
		push_error("CAN NOT RUN INPUT MOVE CONTROLLER, TARGET DNE")
		return
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	# make sure to rotate the basis in the correct direction if there is a camera
	var camera : Camera3D = get_viewport().get_camera_3d()
	var direction : Vector3 = Vector3.ZERO
	if camera:
		var move_basis : Basis = camera.global_transform.basis
		
		move_basis.z.y = 0
		move_basis.x.y = 0
		
		direction =  Vector3(input_dir.x, 0.0, input_dir.y) * move_basis.orthonormalized()
	else:
		direction = (target.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	# handle moving the player
	if direction:
		target.velocity.x = direction.x * SPEED
		target.velocity.z = direction.z * SPEED
		var target_basis = Basis.looking_at(direction.normalized(), Vector3.UP)
		target.basis = target.basis.slerp(target_basis, TURN_WEIGHT).orthonormalized()
	else:
		target.velocity.x = move_toward(target.velocity.x, 0, SPEED)
		target.velocity.z = move_toward(target.velocity.z, 0, SPEED)
