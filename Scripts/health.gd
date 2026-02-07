@tool
extends Control
class_name Health

@export_range(0, 999) var starting_health: int:
	set(value):
		starting_health = value
		current_health = value
		if Engine.is_editor_hint():
			_on_starting_health_changed()

var current_health: int:
	set(value):
		current_health = value
		if not Engine.is_editor_hint():
			_on_current_health_changed()

@onready var health_label: Label = $HealthLabel

func _ready() -> void:
	current_health = starting_health
	_on_current_health_changed()
	
func add_health(amount: int):
	current_health += amount

func subtract_health(amount: int):
	if current_health >= amount:
		current_health -= amount

func _on_starting_health_changed():
	if not is_inside_tree():
		return
	var label: Label = get_node_or_null("HealthLabel")
	if label:
		label.text = str(starting_health)

func _on_current_health_changed():
	if not is_inside_tree():
		return
	if health_label:
		health_label.text = str(current_health)
