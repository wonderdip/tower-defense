extends Node2D
class_name Level

var enemies_alive: Array[Enemy]
var towers: Array[Tower]
@export var waves: Array[Wave]
@export var money: Money
@export var health: Health

func _ready() -> void:
	for wave in waves:
		wave.enemy_spawned.connect(_on_enemy_spawned)
		
func _on_enemy_spawned(enemy: Enemy):
	enemies_alive.append(enemy)
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_finished.connect(_on_enemy_finished)

func _on_enemy_finished(damage: int):
	if health:
		health.subtract_health(damage)
	
func _on_enemy_died(reward: int):
	if money:
		money.add_money(reward)
