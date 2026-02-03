@tool
extends VBoxContainer
class_name ShoptItem

@export var tower: PackedScene:
	set(value):
		tower = value
		_on_tower_changed()
		
@onready var texture_rect: TextureRect = $TextureRect
@onready var buy_button: Button = $BuyButton

func _ready() -> void:
	_on_tower_changed()

func _on_tower_changed():
	if not tower: 
		texture_rect.texture = null
		buy_button.text = "$0"
		return
	
	# Instantiate to access internal sprite data
	var tower_node = tower.instantiate()
	
	# Accessing sprite_2d directly might fail if the child isn't found
	var sprite = tower_node.get_node_or_null("ShopSprite")
	if sprite:
		texture_rect.texture = sprite.texture
	
	buy_button.text = ("$" + str(tower_node.cost))
	# Clean up the temporary instance to prevent memory leaks in editor
	tower_node.queue_free()
	
func _on_buy_button_pressed() -> void:
	if not Engine.is_editor_hint():
		var tower_node = tower.instantiate()
		tower_node.name = tower_node.tower_name
		get_tree().current_scene.add_child(tower_node)
		tower_node.drag_component.start_drag()
