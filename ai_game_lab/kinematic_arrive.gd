extends KinematicMovement

class_name KinematicArrive

func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	var offset = agent.target_position - agent.global_position
	var distance = offset.length()

	if distance < agent.stop_radius:
		return KinematicSteeringOutput.new(Vector2.ZERO, agent.rotation)

	var direction = offset.normalized()

	var speed = agent.max_speed

	if distance < agent.slowing_radius:
		speed *= distance / agent.slowing_radius

	var desired_velocity = direction * speed
	var velocity = _calculate_velocity(agent, desired_velocity)
	var rotation = _calculate_rotation(agent, velocity)
	
	return KinematicSteeringOutput.new(velocity,rotation)


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
	
