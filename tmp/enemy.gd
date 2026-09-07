extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

@export var speed := 100
@export var vision_range := 400

enum State {IDLE, CHASE, ATTACK}
var fsm_config: Dictionary = {}
var prev_state := State.IDLE
var state := State.IDLE

const ATTACK_COOLDOWN_TIME = 2.0
var attack_cooldown = 0

func _ready() -> void:
	fsm_config = {
		State.IDLE: StateDefinition.new([], [], {_player_in_range: State.CHASE, _ready_to_attack: State.ATTACK}),
		State.CHASE: StateDefinition.new([], [_move_towards_player], {_player_lost: State.IDLE, _ready_to_attack: State.ATTACK}),
		State.ATTACK: StateDefinition.new([_start_attack_cooldown], [_attack_player], {_attack_finished: State.CHASE}),
	}
	


func _physics_process(delta: float) -> void:
	attack_cooldown -= delta
	
	_fsm_manager(fsm_config)
	

func _enter_state(entered_state: State):
	var config: StateDefinition = fsm_config[entered_state]
	for action in config.on_enter_actions:
		action.call()

func get_state_name(state_var: State) -> String:
	return State.find_key(state_var)
	
func print_state() -> void:
	print(get_state_name(prev_state), "->", get_state_name(state))

func _change_state(new_state: State):
	prev_state = state
	state = new_state
	_enter_state(new_state)
	print_state()


func _fsm_manager(fsm_config: Dictionary):
	var config: StateDefinition = fsm_config[state]
	
	for action in config.state_actions:
		action.call()
		
	for condition in config.transitions:
		if condition.call():
			var next_state = config.transitions[condition]
			_change_state(next_state)
			break


func _move_towards_player():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func _player_lost() -> bool: 
	var distance = global_position.distance_to(player.global_position)
	if distance > vision_range:
		return true
	return false
	
func _player_in_range() -> bool:
	var distance = global_position.distance_to(player.global_position)
	if distance < vision_range:
		return true
	return false
	
func _ready_to_attack() -> bool:
		if attack_cooldown > 0:
			return false
	
		var bodies = self.get_node("HitBox").get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				return true
		
		return false

func _attack_player() -> void:
	print("Attack!!!")

func _start_attack_cooldown() -> void:
	attack_cooldown = ATTACK_COOLDOWN_TIME

#func _deal_damage_logic() -> void: pass
func _attack_finished() -> bool: return true
