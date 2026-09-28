extends Resource
class_name KinematicSteeringOutput

var velocity: Vector2
var rotation: float

func _init(_velocity: Vector2 = Vector2.ZERO, _rotation: float = 0.0):
	velocity = _velocity
	rotation = _rotation
