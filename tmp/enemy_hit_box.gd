extends Area2D

signal attack_player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta):

	var bodies = get_overlapping_bodies()

	for body in bodies:
		if body.is_in_group("player"):
			attack_player.emit()
