extends Node2D
class_name Tower

@export var tower_name: String = ""
@export var cost: int
enum Tower_type {Land, Water}
@export var type: Tower_type

@onready var attack_component: AttackComponent = $AttackComponent
@onready var drag_component: Node = $DragComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shop_sprite: Sprite2D = $ShopSprite
@onready var gun_sprite: Sprite2D = $GunSprite

var placed: bool:
	set(value):
		placed = value
		_on_tower_placed()

var cell: Vector2i

func spawned():
	drag_component.start_drag()

func _on_tower_placed():
	shop_sprite.hide()
	if animated_sprite_2d:
		animated_sprite_2d.show()
		animated_sprite_2d.play("idleforward")
		if gun_sprite:
			gun_sprite.show()
		
func _process(delta: float) -> void:
	if attack_component.target and placed:
		gun_sprite.look_at(attack_component.target.global_position)
		
		if attack_component.target.global_position.x < global_position.x:
			gun_sprite.scale = Vector2(-1, -1)
			animated_sprite_2d.flip_h = false
		else:
			gun_sprite.scale = Vector2(-1, 1)
			animated_sprite_2d.flip_h = true
			
		if attack_component.target.global_position.y < global_position.y:
			animated_sprite_2d.play("idlebackward")
		else:
			animated_sprite_2d.play("idleforward")
