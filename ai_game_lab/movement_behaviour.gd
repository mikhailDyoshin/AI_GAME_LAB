extends Resource
class_name KinematicMovement


func calculate(agent: CharacterBody2D) -> KinematicSteeringOutput:
	return KinematicSteeringOutput.new(Vector2.ZERO, 0.0)
