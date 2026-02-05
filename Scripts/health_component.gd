extends Node
class_name HealthComponent

signal died

@export var max_health: float = 100
@export var sprite: Sprite2D
@export var parent_node: Enemy
var current_health: float
var is_taking_damage: bool = false

func _ready():
	current_health = max_health

func take_damage(amount: float):
	sprite.modulate = Color.RED
	current_health -= amount
	is_taking_damage = true
	
	if current_health <= 0:
		current_health = 0
		died.emit()
		
	await get_tree().create_timer(0.3, true, false, false).timeout
	is_taking_damage = false
	sprite.modulate = Color.WHITE
