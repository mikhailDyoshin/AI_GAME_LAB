class_name StateDefinition
extends RefCounted

var state_actions: Array[Callable] = []
var on_enter_actions: Array[Callable] = []
var transitions: Dictionary = {}

func _init(p_enter: Array[Callable] = [], p_actions: Array[Callable] = [], p_transitions: Dictionary = {}):
	on_enter_actions = p_enter
	state_actions = p_actions
	transitions = p_transitions
