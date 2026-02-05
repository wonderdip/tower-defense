extends Node2D
class_name Wave

@export var level_path: Path2D
@export var enemy: PackedScene
@export var spawn_amount: int
@export var spawn_timer: float

func _ready() -> void:
	start_wave()
	
func start_wave():
	for i in range(spawn_amount):
		var enemy_instance = enemy.instantiate() as Enemy
		enemy_instance.path = level_path
		level_path.add_child(enemy_instance)
		await get_tree().create_timer(spawn_timer).timeout
