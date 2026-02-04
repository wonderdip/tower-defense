extends Node
class_name HealthComponent

signal died

@export var max_health: float = 100
@export var sprite: Sprite2D
var current_health: float

func _ready():
	current_health = max_health

func take_damage(amount: float):
	sprite.modulate = Color.RED
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		emit_signal("died")
	await get_tree().create_timer(0.5, true, false, false).timeout
	sprite.modulate = Color.WHITE
