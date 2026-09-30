extends Resource
class_name KinematicContext

var agent: CharacterBody2D
var rotation: float
var velocity: Vector2
var max_force: float
var max_speed: float
var target_position: Vector2
var direction: Vector2
var distance: float
var stop_radius: float
var slowing_radius: float

func _init(
	_agent: CharacterBody2D = null,
	_velocity: Vector2 = Vector2.ZERO,
	_rotation: float = 0.0,
	_max_speed: float = 0.0,
	_max_force: float = 0.0,
	_target_position: Vector2 = Vector2.ZERO,
	_direction: Vector2 = Vector2.ZERO,
	_distance: float = 0.0,
	_stop_radius: float = 0.0,
	_slowing_radius: float = 0.0
) -> void:
	agent = _agent
	velocity = _velocity
	rotation = _rotation
	max_speed = _max_speed
	max_force = _max_force
	target_position = _target_position
	direction = _direction
	distance = _distance
	stop_radius = _stop_radius
	slowing_radius = _slowing_radius
