@tool
extends Area2D
class_name RangeComponent

signal in_range(area: Area2D)
signal out_of_range(area: Area2D)

@export var radius: float:
	set(value):
		radius = value
		_on_radius_changed()
		
enum UnitType { TOWER, ENEMY }
@export var type: UnitType:
	set(value):
		type = value
		if Engine.is_editor_hint():
			_change_type()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var range_texture: TextureRect = $RangeTexture
@onready var range_circle: ColorRect = $RangeCircle

func _ready() -> void:
	_on_radius_changed()
	_change_type()

func _change_type():
	reset_layers()
	match type:
		UnitType.TOWER:
			set_collision_layer_value(1, true) # Tower
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
			range_circle.show()
			
		UnitType.ENEMY:
			set_collision_layer_value(2, true)
			set_collision_mask_value(4, true)
			range_circle.hide()
			
func reset_layers():
	for layer in range(1, 33):
		set_collision_layer_value(layer, false)
		set_collision_mask_value(layer, false)

func _on_radius_changed():
	if collision_shape_2d:
		collision_shape_2d.shape.radius = radius
		
		range_circle.size = Vector2(radius, radius) * 2
		range_circle.pivot_offset = Vector2(radius, radius)
		range_circle.position = Vector2(-radius, -radius)
		
func _on_area_entered(area: Area2D) -> void:
	in_range.emit(area)

func _on_area_exited(area: Area2D) -> void:
	out_of_range.emit(area)
