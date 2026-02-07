extends Node2D
class_name World

@export var money: Money
@export var current_level: Level

func _ready() -> void:
	if current_level and money:
		current_level.money = money
