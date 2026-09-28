extends Resource
class_name KinematicMovement


func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	return KinematicSteeringOutput.new(Vector2.ZERO, 0.0)


func _calculate_velocity(agent: CharacterBody2D, desired_velocity: Vector2) -> Vector2:
	return agent.velocity + (desired_velocity - agent.velocity).limit_length(agent.max_force)


func _calculate_rotation(
	agent: CharacterBody2D,
	velocity: Vector2
) -> float:
	if velocity.length_squared() < 1.0:
		return agent.rotation

	var target_angle := velocity.angle() - PI / 2
	return lerp_angle(agent.rotation, target_angle, 0.1)
