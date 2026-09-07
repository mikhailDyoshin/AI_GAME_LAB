extends CharacterBody2D


@export var SPEED = 600.0
@export var MAX_FORCE = 40.0
@export var SLOWING_RADIUS = 100
@export var STOP_RADIUS = 0.05

var target_position: Vector2 = Vector2.ZERO


func _ready():
	target_position = global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_position = get_global_mouse_position()

func _physics_process(delta):
	var distance_to_target = global_position.distance_to(target_position)
	
	if distance_to_target < STOP_RADIUS:
		stop()
		return
	
	steer(distance_to_target)
	
	if velocity.length() > 1.0:
		rotate_character()
		
	move_and_slide()

func stop():
	velocity = Vector2.ZERO
	global_position = target_position
	
func steer(distance_to_target: float):
	var direction = (target_position - global_position).normalized()
	var target_speed = SPEED
	
	if distance_to_target < SLOWING_RADIUS:
		var speed_factor = distance_to_target / SLOWING_RADIUS
		target_speed = SPEED * speed_factor
		
	var desired_velocity = direction * target_speed
	var steering_force = desired_velocity - velocity
	steering_force = steering_force.limit_length(MAX_FORCE)
	velocity += steering_force
	
func rotate_character():
	var target_angle = velocity.angle() - PI/2
	rotation = lerp_angle(rotation, target_angle, 0.1)
