extends Node2D
class_name AttackComponent

@export var damage: float
@export var atk_speed: float

@export var parent_node: Tower
@export var range_component: RangeComponent

@onready var attack_timer: Timer = $AttackTimer

var can_attack: bool = true
var enemies_in_range: Array[Enemy] = []
var target: Enemy = null

func _ready():
	if range_component:
		range_component.in_range.connect(_on_in_range)
		range_component.out_of_range.connect(_on_out_of_range)

func _on_in_range(area: RangeComponent):
	var enemy := area.get_parent() as Enemy
	if enemy:
		enemies_in_range.append(enemy)
		update_target()

func _on_out_of_range(area: RangeComponent):
	var enemy := area.get_parent() as Enemy
	if enemy:
		enemies_in_range.erase(enemy)
		update_target()
		
func on_tower_placed():
	if not enemies_in_range.is_empty():
		update_target()
		
func update_target():
	if enemies_in_range.is_empty():
		target = null
		return
	
	var best_enemy := enemies_in_range[0]
	var best_progress := best_enemy.path_follow.progress_ratio
	
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):
			continue
		
		var p := enemy.path_follow.progress_ratio
		if p > best_progress:
			best_progress = p
			best_enemy = enemy
	
	target = best_enemy
	if parent_node.placed:
		try_attack()
		
func try_attack():
	if not can_attack:
		return
	if target == null:
		return
		
	attack()

func attack():
	if target == null:
		return
	print("Attacking ", target.name)
	parent_node.modulate = Color.RED

	# Try to find a HealthComponent on the target
	var health = target.health_component as HealthComponent
	if health:
		health.take_damage(damage)
	
	can_attack = false
	attack_timer.start(atk_speed)
	await get_tree().create_timer(0.1, true, false, false).timeout
	parent_node.modulate = Color.WHITE
	
func _on_attack_timer_timeout():
	parent_node.modulate = Color.WHITE
	can_attack = true
	try_attack() # only attack again if still in range
