extends CharacterBody2D


@export var max_speed = 600.0
@export var max_force = 60.0
@export var slowing_radius = 100
@export var stop_radius = 0.1

var target_position: Vector2 = Vector2.ZERO

@onready var file = FileAccess.open("user://game_logs.txt", FileAccess.WRITE)


func _ready():
	target_position = global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_position = get_global_mouse_position()

func _physics_process(delta):
	apply_kinematics(KinematicMovement.arrive(_get_context()))
	move_and_slide()

func apply_kinematics(kinemtic_steering_output: KinematicSteeringOutput):
	velocity = kinemtic_steering_output.velocity
	rotation = kinemtic_steering_output.rotation

func random_binomial():
	return randf() - randf()

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
		slowing_radius
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
