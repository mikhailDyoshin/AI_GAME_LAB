extends KinematicMovement

class_name KinematicSeek

func _seek_speed_policy(agent: CharacterBody2D) -> float:
	return agent.max_speed

func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	
	return _calculate_steering_output(agent, _seek_speed_policy)
