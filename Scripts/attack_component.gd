extends Node2D
class_name AttackComponent

@export var damage: float
@export var atk_speed: float

@export var parent_node: Node2D
@export var range_component: RangeComponent

@onready var attack_timer: Timer = $AttackTimer

var can_attack: bool = true
var target: Enemy = null

func _ready():
	if range_component:
		range_component.in_range.connect(_on_in_range)
		range_component.out_range.connect(_on_out_range)

func _on_in_range(area: RangeComponent):
	target = area.get_parent() as Enemy
	try_attack()

func _on_out_range(area: RangeComponent):
	if area == target:
		target = null

func try_attack():
	if not can_attack:
		return
	if target == null:
		return
		
	attack()

func attack():
	if target == null:
		return
	print("Attacking", target.name)
	parent_node.modulate = Color.AQUA

	# Try to find a HealthComponent on the target
	var health = target.health_component as HealthComponent
	if health:
		health.take_damage(damage)

	can_attack = false
	attack_timer.start(atk_speed)


func _on_attack_timer_timeout():
	parent_node.modulate = Color.GREEN
	can_attack = true
	try_attack() # only attack again if still in range
