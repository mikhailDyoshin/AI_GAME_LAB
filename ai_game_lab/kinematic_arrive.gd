extends KinematicMovement

class_name KinematicArrive

func _arrive_speed_policy(agent) -> float:
	var distance = _get_distance_to_target(agent)
	var speed = agent.max_speed
	
	if distance < agent.stop_radius:
		return 0

	if distance < agent.slowing_radius:
		speed *= distance / agent.slowing_radius
		return speed
		
	return speed

func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	return _calculate_steering_output(agent, _arrive_speed_policy)
