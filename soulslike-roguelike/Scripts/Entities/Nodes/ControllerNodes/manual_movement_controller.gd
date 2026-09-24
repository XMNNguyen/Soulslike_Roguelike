extends ControllerNode
class_name InputMovementController

@export var SPEED : float = 4.5
@export var TURN_WEIGHT : float = 0.5
@export var target : CharacterBody3D = null


func run(delta : float) -> void:
	if target == null:
		push_error("CAN NOT RUN INPUT MOVE CONTROLLER, TARGET DNE")
		return
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := Vector3(input_dir.x, 0.0, input_dir.y)
	
	# make sure to rotate the basis in the correct direction if there is a camera
	var camera := get_viewport().get_camera_3d()

	if camera:
		var forward := -camera.global_transform.basis.z # we use negative to have character facing away from camera
		var right := camera.global_transform.basis.x

		# Ignore camera pitch
		forward.y = 0.0
		right.y = 0.0

		forward = forward.normalized()
		right = calc_orbit_velocity(input_dir)

		direction = right * input_dir.x + forward * -input_dir.y
	else:
		direction = Vector3(input_dir.x, 0.0, input_dir.y)

	if direction:
		direction = direction.normalized()

		target.velocity.x = direction.x * SPEED
		target.velocity.z = direction.z * SPEED

		var target_basis := Basis.looking_at(-direction, Vector3.UP)
		target.basis = target.basis.slerp(target_basis, TURN_WEIGHT)
	else:
		target.velocity.x = move_toward(target.velocity.x, 0.0, SPEED)
		target.velocity.z = move_toward(target.velocity.z, 0.0, SPEED)


# helper function to orbit player around the camera
func calc_orbit_velocity(input : Vector2) -> Vector3:
	var camera := get_viewport().get_camera_3d()
	var camera_pos := camera.global_position
	camera_pos.y = 0.0
	var target_direction = camera_pos - target.global_position
	var distance_to_target = target_direction.length()
	
	var alpha = (2 * asin(SPEED / (2 * distance_to_target)))
	var d_vector = (target_direction.rotated(Vector3.UP, alpha) - target_direction).normalized()
	
	return d_vector
	
