extends CharacterBody2D


@export var max_speed = 600.0
@export var max_force = 60.0
@export var slowing_radius = 100
@export var stop_radius = 0.1
@export var flee_radius = 400.0
@export var flee_stop_radius = 600.0
@export var world_size := Vector2(1152, 648) 

var target_position: Vector2 = Vector2.ZERO

@onready var file = FileAccess.open("user://game_logs.txt", FileAccess.WRITE)

var movements = [
	MovementType.new("Arrive", KinematicMovement.arrive), 
	MovementType.new("Chaotic", KinematicMovement.chaotic),
	MovementType.new("Align", KinematicMovement.align),
	MovementType.new("Seek", KinematicMovement.seek),
	MovementType.new("Flee", KinematicMovement.flee),
	MovementType.new("Wander", KinematicMovement.wander)
]
var current_index = 0
var current_movement = movements[0]

func _ready():
	target_position = global_position
	print(current_movement.name)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_position = get_global_mouse_position()
		
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_SPACE:
			switch_movement()
		
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		target_position = get_global_mouse_position()

func _physics_process(delta):
	apply_kinematics(current_movement.function.call(_get_context()))
	move_and_slide()
	
	global_position.x = fposmod(global_position.x, world_size.x)
	global_position.y = fposmod(global_position.y, world_size.y)

func apply_kinematics(kinemtic_steering_output: KinematicSteeringOutput):
	velocity = kinemtic_steering_output.velocity
	rotation = kinemtic_steering_output.rotation

func save_text_log(message: String):
	if file:
		file.seek_end()
		file.store_line(message)
	else:
		print("Ошибка открытия файла: ", FileAccess.get_open_error())

func _get_context() -> KinematicContext:
	var offset: Vector2 = target_position - global_position
	var current_distance: float = offset.length()
	var current_direction: Vector2 = offset.normalized() if current_distance > 0.0 else Vector2.ZERO
	
	return KinematicContext.new(
		self,
		velocity,
		rotation,
		max_speed,
		max_force,
		target_position,
		current_direction,
		current_distance,
		stop_radius,
		slowing_radius,
		flee_radius,
		flee_stop_radius,
	)

#func log_steering():
	#file = FileAccess.open("user://game_logs.txt", FileAccess.READ_WRITE)
#
	#var data = {
		#"velocity": velocity.length(), 
		#"force": steering_force().length(), 
		#"distance_to_target": distance_to_target(),
		#"direction": {"x": direction().x, "y": direction().y}
	#}
	#
	#save_text_log(JSON.stringify(data))

func get_next_cyclic_index(current_index: int, array_size: int) -> int:
	if array_size == 0:
		return 0
	return (current_index + 1) % array_size

func switch_movement():
	current_index = get_next_cyclic_index(current_index, movements.size())
	current_movement = movements[current_index]
	print(current_movement.name)
	
