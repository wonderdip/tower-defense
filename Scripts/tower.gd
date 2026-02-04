extends Node2D
class_name Tower

@export var tower_name: String = ""
@export var cost: int

@onready var drag_component: Node = $DragComponent
var placed: bool

func spawned():
	drag_component.start_drag()
