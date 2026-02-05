extends Node2D
class_name DragComponent

@export var parent_node: Tower
var drag: bool

func start_drag():
	if parent_node == null:
		return
		
	drag = true

func end_drag():
	if parent_node == null:
		return
	drag = false
	
func _process(delta: float) -> void:
	if drag:
		var mouse_world = get_global_mouse_position()
		parent_node.global_position = parent_node.global_position.lerp(
		mouse_world,
		15 * delta
		)
