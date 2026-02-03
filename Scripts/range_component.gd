@tool
extends Area2D
class_name RangeComponent

signal in_range(area: Area2D)
signal out_range(area: Area2D)

@export var radius: float:
	set(value):
		radius = value
		print("range changed")
		_on_radius_changed()
		
enum UnitType { TOWER, ENEMY }
@export var type: UnitType:
	set(value):
		type = value
		if Engine.is_editor_hint():
			_setup_collision()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_on_radius_changed()
	_setup_collision()

func _setup_collision():
	reset_layers()
	match type:
		UnitType.TOWER:
			set_collision_layer_value(1, true) # Tower
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
			
		UnitType.ENEMY:
			set_collision_layer_value(2, true)
			set_collision_mask_value(4, true)

func reset_layers():
	for layer in range(1, 33):
		set_collision_layer_value(layer, false)
		set_collision_mask_value(layer, false)

func _on_radius_changed():
	if collision_shape_2d:
		collision_shape_2d.shape.radius = radius

func _on_area_entered(area: Area2D) -> void:
	in_range.emit(area)

func _on_area_exited(area: Area2D) -> void:
	out_range.emit(area)
