extends Node2D
class_name Enemy

signal enemy_died(reward: int)
signal enemy_finished(damage: int)

@export var title: String = ""
@export var speed: float = 60
@export var damage: int = 10
@export var reward: int = 10
@export var weight: float = 40
@export var range_component: RangeComponent
@export var health_component: HealthComponent

var path: Path2D
var path_follow: PathFollow2D

func _ready():
	if range_component:
		range_component.in_range.connect(_on_in_range)
	if health_component:
		health_component.died.connect(_on_died)
	
	# Create PathFollow2D as a child of the path
	if path:
		global_position = path.curve.get_point_position(0)
		path_follow = PathFollow2D.new()
		path.call_deferred("add_child", path_follow, true)
		path_follow.loop = false
		path_follow.rotates = false
		path_follow.cubic_interp = true
		# Reparent self to the PathFollow2D
		call_deferred("reparent", path_follow)
		
func _on_in_range(area: Area2D):
	if area.collision_layer & 8 != 0:
		enemy_finished.emit(damage)
		path_follow.queue_free()
		
func _process(delta):
	if not path_follow:
		return
	# Move along the path
	if not health_component.is_taking_damage:
		path_follow.progress += speed * delta
	else:
		var target: float = path_follow.progress_ratio - (weight / 500) / 2
		path_follow.progress_ratio = lerpf(path_follow.progress_ratio, target, (speed / weight) * delta)

func _on_died() -> void:
	enemy_died.emit(reward)
	queue_free()
