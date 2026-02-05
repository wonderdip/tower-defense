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
			if is_on_grass():
				# Confirm placement
				added_tower.drag_component.end_drag()
				added_tower.placed = true
				
				if added_tower.attack_component:
					added_tower.attack_component.on_tower_placed()
					
				added_tower = null
				can_spawn = false
			
func is_on_grass() -> bool:
	var tilemap = level.get_node_or_null("TileMapLayer") as TileMapLayer
	if tilemap == null or tilemap.tile_set == null:
		return false
	
	# Convert the tower's global position to the tilemap's local space
	var local_pos = tilemap.to_local(added_tower.global_position)
	
	# Convert local position to tile coordinates
	var cell: Vector2i = tilemap.local_to_map(local_pos)
	
	# Get the tile data at that cell
	var tile_data: TileData = tilemap.get_cell_tile_data(cell)
	
	if tile_data:
		var terrain = tile_data.get_terrain()
		return terrain == 1  # Return true if Grass (terrain index 1)
	
	return false
		
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
		snap_to_nearest_grass_tile()

func snap_to_nearest_grass_tile() -> void:
	var tilemap = level.get_node_or_null("TileMapLayer") as TileMapLayer
	if tilemap == null:
		return
	
	# Get mouse position in tilemap space
	var mouse_global = get_global_mouse_position()
	var local_pos = tilemap.to_local(mouse_global)
	var cell: Vector2i = tilemap.local_to_map(local_pos)
	
	# Snap to tile center
	var tile_center_local = tilemap.map_to_local(cell)
	var tile_center_global = tilemap.to_global(tile_center_local)
	
	added_tower.global_position = tile_center_global
