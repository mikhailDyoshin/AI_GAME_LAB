extends Resource

class_name MovementType

var name: String
var function: Callable

func _init(_name: String, _function: Callable):
	name = _name
	function = _function
