extends KinematicMovement

class_name KinematicSeek

func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	var offset = agent.target_position - agent.global_position
	var direction = offset.normalized()
	var speed = agent.max_speed
	var desired_velocity = direction * speed
	var velocity = _calculate_velocity(agent, desired_velocity)
	var rotation = _calculate_rotation(agent, velocity)
	
	return KinematicSteeringOutput.new(velocity,rotation)
