extends CharacterBody2D


@export var max_speed: float = 600.0
@export var max_speed_change: float = 60.0
@export var slowing_radius: float = 100
@export var stop_radius: float = 0.1
@export var flee_radius: float  = 400.0
@export var flee_stop_radius: float = 600.0
@export var world_size: Vector2 = Vector2(1152, 648) 
@export var max_prediction_time: float = 0.1
var target_position: Vector2 = Vector2.ZERO
var _last_target_position := Vector2.ZERO

var target_velocity := Vector2.ZERO

var predicted_position := Vector2.ZERO

@onready var file = FileAccess.open("user://game_logs.txt", FileAccess.WRITE)

var movements = [
	MovementType.new("Pursue", KinematicMovement.pursue), 
	MovementType.new("Arrive", KinematicMovement.arrive), 
	MovementType.new("Chaotic", KinematicMovement.chaotic),
	MovementType.new("Align", KinematicMovement.align),
	MovementType.new("Seek", KinematicMovement.seek),
	MovementType.new("Evade", KinematicMovement.evade), 
	MovementType.new("Flee", KinematicMovement.flee),
	MovementType.new("Wander", KinematicMovement.wander)
]
var current_index = 0
var current_movement = movements[0]

var started = false

func _ready():
	EventBus.value_updated.connect(_on_value_updated)
	EventBus.target_position_updated.connect(_on_target_position_updated)
	target_position = global_position
	print(current_movement.name)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		started = true
		
		
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_SPACE:
			switch_movement()
		
func _process(delta: float) -> void:
	queue_redraw()
	target_velocity = _get_target_velocity(delta)
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#_last_target_position = target_position
		#target_position = get_global_mouse_position()
		#target_velocity = _get_target_velocity(delta)
	#else:
		#target_velocity = Vector2.ZERO
	#print(target_velocity.length())
	


func _physics_process(delta):
	if started:
		apply_kinematics(current_movement.function.call(_get_context()))
		
	move_and_slide()
	
	global_position.x = fposmod(global_position.x, world_size.x)
	global_position.y = fposmod(global_position.y, world_size.y)


func _draw() -> void:
	draw_circle(to_local(predicted_position), 5.0, Color.WEB_GREEN)

func apply_kinematics(kinemtic_steering_output: KinematicSteeringOutput):
	velocity = kinemtic_steering_output.velocity
	rotation = kinemtic_steering_output.rotation

func save_text_log(message: String):
	if file:
		file.seek_end()
		file.store_line(message)
	else:
		print("Ошибка открытия файла: ", FileAccess.get_open_error())

func _get_target_velocity(delta: float) -> Vector2:
	return (target_position - _last_target_position)/delta

func _get_context() -> KinematicContext:
	return KinematicContext.new(self)

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
	
	
func _on_value_updated(new_value: Variant) -> void:
	# Обновляем текст на экране при получении новых данных
	predicted_position = new_value

func _on_target_position_updated(new_target_position: Vector2) -> void:
	_last_target_position = target_position
	target_position = new_target_position
	
