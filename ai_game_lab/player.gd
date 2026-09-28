extends CharacterBody2D


@export var max_speed = 600.0
@export var max_force = 60.0
@export var slowing_radius = 100
@export var stop_radius = 0.1

var target_position: Vector2 = Vector2.ZERO

@onready var file = FileAccess.open("user://game_logs.txt", FileAccess.WRITE)

var kinematic_arrive: KinematicArrive = KinematicArrive.new()

func _ready():
	target_position = global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_position = get_global_mouse_position()

func _physics_process(delta):
	apply_kinematics(kinematic_arrive.calculate(self))
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
