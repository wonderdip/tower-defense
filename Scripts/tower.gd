extends Node2D
class_name Tower

@export var tower_name: String = ""
@export var cost: int

@onready var drag_component: Node = $DragComponent
var placed: bool

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not placed:
		if event.pressed:
			drag_component.start_drag()
		else:
			placed = true
			drag_component.end_drag()
