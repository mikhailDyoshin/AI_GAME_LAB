extends CharacterBody2D


@export var max_speed: float = 600.0
@export var max_speed_change: float = 60.0
@export var slowing_radius: float = 100
@export var stop_radius: float = 0.1
@export var flee_radius: float  = 400.0
@export var flee_stop_radius: float = 600.0
@export var world_size: Vector2 = Vector2(1152, 648) 
@export var max_prediction_time: float = 0.001

var target_position: Vector2 = Vector2.ZERO
var current_index = 0
var target_velocity = Vector2.ZERO

var started = false

func _ready():
	target_position = global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_position = get_global_mouse_position()
		started = true
		
				
func _process(delta: float) -> void:
	queue_redraw()
	

func _physics_process(delta):
	apply_kinematics(KinematicMovement.arrive.call(_get_context()))
	move_and_slide()
	
	global_position.x = fposmod(global_position.x, world_size.x)
	global_position.y = fposmod(global_position.y, world_size.y)
	
	if started:
		EventBus.target_position_updated.emit(global_position)


func _draw() -> void:
	draw_circle(to_local(global_position), 5.0, Color.RED)

func apply_kinematics(kinemtic_steering_output: KinematicSteeringOutput):
	velocity = kinemtic_steering_output.velocity
	rotation = kinemtic_steering_output.rotation


func _get_context() -> KinematicContext:
	return KinematicContext.new(self)
