extends Resource
class_name KinematicContext

var agent: CharacterBody2D
var rotation: float
var velocity: Vector2
var max_speed_change: float
var max_speed: float
var target_position: Vector2
var direction: Vector2
var distance: float
var stop_radius: float
var slowing_radius: float
var flee_radius: float
var flee_stop_radius: float
var target_velocity: Vector2
var max_prediction_time: float

func _init(
	_agent: CharacterBody2D,
) -> void:
	if _agent == null:
		return
	
	agent = _agent
	velocity = _agent.velocity
	rotation = _agent.rotation
	max_speed = _agent.max_speed
	max_speed_change = _agent.max_speed_change
	target_position = _agent.target_position
	stop_radius = _agent.stop_radius
	slowing_radius = _agent.slowing_radius
	flee_radius = _agent.flee_radius
	flee_stop_radius = _agent.flee_stop_radius
	target_velocity = _agent.target_velocity
	max_prediction_time = _agent.max_prediction_time
	update_target(_agent.target_position)
	
	
func update_target(new_target_position: Vector2) -> void:
	var offset: Vector2 = new_target_position - self.agent.global_position
	var current_distance: float = offset.length()
	var current_direction: Vector2 = offset.normalized() if current_distance > 0.0 else Vector2.ZERO
	direction = current_direction
	distance = current_distance
