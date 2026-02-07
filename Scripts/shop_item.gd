@tool
extends VBoxContainer
class_name ShoptItem

@export var tower: PackedScene:
	set(value):
		tower = value
		if Engine.is_editor_hint():
			_on_tower_changed()
			
@export var level: Node2D
@onready var item_texture: TextureRect = $ItemTexture
@onready var buy_button: Button = $BuyButton
@onready var money: Money = $"../../../../../PanelContainer/HBoxContainer/Money"

var can_spawn: bool = false
var added_tower: Tower
var mouse_over_panel: bool = false

func _ready() -> void:
	_on_tower_changed()

func _on_tower_changed():
	# Get nodes directly for @tool compatibility
	var texture_node = get_node_or_null("ItemTexture")
	var button_node = get_node_or_null("BuyButton")
	
	if not texture_node or not button_node:
		return
	
	if not tower: 
		texture_node.texture = null
		button_node.text = "$0"
		return
	
	var tower_node = tower.instantiate() as Tower
	var sprite = tower_node.get_node_or_null("ShopSprite")
	if sprite:
		texture_node.texture = sprite.texture
	
	button_node.text = ("$" + str(tower_node.cost))
	tower_node.queue_free()

func add_tower():
	if not Engine.is_editor_hint() and not added_tower:
		var tower_node = tower.instantiate()
		get_tree().current_scene.add_child(tower_node)
		tower_node.name = tower_node.tower_name
		tower_node.global_position = get_global_mouse_position()
		tower_node.spawned()
		added_tower = tower_node
		can_spawn = true

func remove_tower():
	if not Engine.is_editor_hint() and added_tower:
		added_tower.queue_free()
		added_tower = null
		can_spawn = false

func _input(event: InputEvent) -> void:
	# Only handle input if THIS shop item has a tower spawned
	if not can_spawn or not added_tower:
		return
	
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		
		if mouse_over_panel:
			# Cancel - mouse released over panel
			remove_tower()
		else:
			if added_tower.type == added_tower.Tower_type.Land:
				if is_on_terrain("Grass") and money.can_buy(added_tower.cost) and is_on_empty_tile():
					confirm_placement()
				else:
					remove_tower()
			elif added_tower.type == added_tower.Tower_type.Water:
				if is_on_terrain("Water") and money.can_buy(added_tower.cost) and is_on_empty_tile():
					confirm_placement()
				else:
					remove_tower()

func confirm_placement():
		added_tower.drag_component.end_drag()
		added_tower.placed = true
		money.subtract_money(added_tower.cost)
		level.towers.append(added_tower)
		
		if added_tower.attack_component:
			added_tower.attack_component.on_tower_placed()
			
		added_tower = null
		can_spawn = false

func is_on_terrain(terrain: String) -> bool:
	var tilemap = level.get_node_or_null("TileMapLayer") as TileMapLayer
	if tilemap == null or tilemap.tile_set == null:
		return false
	
	var margin := 8
	var pos := added_tower.global_position
	
	var points := [
		pos,
		pos + Vector2(-margin, -margin),
		pos + Vector2(margin, -margin),
		pos + Vector2(-margin, margin),
		pos + Vector2(margin, margin),
	]
	
	for p in points:
		var local_pos = tilemap.to_local(p)
		var cell: Vector2i = tilemap.local_to_map(local_pos)
		var tile_data: TileData = tilemap.get_cell_tile_data(cell)
		
		if not tile_data:
			return false
		
		match terrain:
			"Grass":
				if tile_data.get_terrain() != 1:
					return false
			"Water":
				if tile_data.get_terrain() != 2:
					return false
	
	# Store main cell (for placement)
	var main_cell = tilemap.local_to_map(tilemap.to_local(pos))
	added_tower.cell = main_cell
	
	return true
	
func is_on_empty_tile() -> bool:
	var min_distance := 32  # one tower width
	
	for tower in level.towers:
		if tower == added_tower:
			continue
		
		if added_tower.global_position.distance_to(tower.global_position) < min_distance:
			return false
	
	return true
	
func _on_buy_button_button_down() -> void:
	if not can_spawn:
		add_tower()

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	if mouse_pos.x >= 520 and mouse_pos.y >= 0 and added_tower:
		mouse_over_panel = true
		added_tower.hide() 
	elif added_tower:
		mouse_over_panel = false
		added_tower.show()
		# Snap to nearest tile in real-time
		
		if ((added_tower.type == added_tower.Tower_type.Land and not is_on_terrain("Grass"))
		or (added_tower.type == added_tower.Tower_type.Water and not is_on_terrain("Water")) 
		or not money.can_buy(added_tower.cost) 
		or not is_on_empty_tile()):
			
			added_tower.modulate = Color.GRAY
		else:
			added_tower.modulate = Color.WHITE
			
