extends Node
class_name HealthComponent

signal died

@export var max_health: float = 100
var current_health: float

func _ready():
	current_health = max_health

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		emit_signal("died")
