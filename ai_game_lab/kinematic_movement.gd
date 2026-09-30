extends Resource
class_name KinematicMovement


func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	return KinematicSteeringOutput.new(Vector2.ZERO, 0.0)


func _calculate_steering_output(agent: CharacterBody2D, speed_policy: Callable) -> KinematicSteeringOutput:
	var desired_velocity = _get_direction_to_target(agent) * speed_policy.call(agent)
	var velocity = _calculate_velocity(agent, desired_velocity)
	var rotation = _calculate_rotation(agent, velocity)
	
	return KinematicSteeringOutput.new(velocity,rotation)


func _calculate_velocity(agent: CharacterBody2D, desired_velocity: Vector2) -> Vector2:
	return agent.velocity + (desired_velocity - agent.velocity).limit_length(agent.max_force)


func _get_offset(agent: CharacterBody2D) -> Vector2:
	return agent.target_position - agent.global_position

func _get_direction_to_target(agent: CharacterBody2D) -> Vector2:
	return _get_offset(agent).normalized()
	
func _get_distance_to_target(agent: CharacterBody2D) -> float:
	return _get_offset(agent).length()
	

func _calculate_rotation(
	agent: CharacterBody2D,
	velocity: Vector2
) -> float:
	if velocity.length_squared() < 1.0:
		return agent.rotation

	var target_angle := velocity.angle() - PI / 2
	return lerp_angle(agent.rotation, target_angle, 0.1)
