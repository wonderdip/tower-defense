extends Node2D
class_name Wave

@export var level_path: Path2D
@export var next_wave: Wave
@export var enemy: PackedScene
@export var spawn_amount: int
@export var spawn_timer: float
@export var next_wave_timer: float
@export var starting_wave: bool

func _ready() -> void:
	if starting_wave:
		start_wave()
	
func start_wave():
	for i in range(spawn_amount):
		var enemy_instance = enemy.instantiate() as Enemy
		enemy_instance.path = level_path
		level_path.add_child(enemy_instance)
		await get_tree().create_timer(spawn_timer).timeout
		
	await get_tree().create_timer(next_wave_timer).timeout
	end_wave()
	
func end_wave():
	if next_wave:
		next_wave.start_wave()
