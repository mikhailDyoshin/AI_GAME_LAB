extends Node2D

const TARGET_SCENE = preload("res://target.tscn")

@export var position_x = 900
@export var position_y = 50

func _ready() -> void:
	var target = TARGET_SCENE.instantiate()
	target.global_position = Vector2(1000, 50)
	$"../Targets".add_child(target)
	print("Spawned Target")
