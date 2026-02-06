extends Node2D
class_name Level

var enemies_alive: Array[Enemy]
@export var waves: Array[Wave]

func _ready() -> void:
	for wave in waves:
		wave.connect("enemy_spawned", _on_enemy_spawned)
		
func _on_enemy_spawned(enemy: Enemy):
	enemies_alive.append(enemy)
	
