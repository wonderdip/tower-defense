@tool
extends Node2D
class_name ShadowComponent


enum ShadowSize {Small, Medium, Big}
@export var shadow_size: ShadowSize:
	set(value):
		shadow_size = value
		if Engine.is_editor_hint():
			_on_shadow_size_changed()

func _ready() -> void:
	_on_shadow_size_changed()
	
func _on_shadow_size_changed():
	var shadow_sprite = get_node_or_null("ShadowSprite") as Sprite2D
	shadow_sprite.region_enabled = true
	shadow_sprite.region_rect = Rect2(0, 0, 0, 0)
	
	match shadow_size:
		ShadowSize.Small:
			shadow_sprite.region_rect = Rect2(0, 0, 10, 16)
		ShadowSize.Medium:
			shadow_sprite.region_rect = Rect2(10, 0, 16, 16)
		ShadowSize.Big:
			shadow_sprite.region_rect = Rect2(26, 0, 32, 16)
