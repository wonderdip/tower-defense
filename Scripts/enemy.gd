extends Node2D
class_name Enemy

@export var title: String = ""
@export var speed: float = 60
@export var range_component: RangeComponent
@export var health_component: HealthComponent
@export var path: Path2D

var path_follow: PathFollow2D

func _ready():
	if range_component:
		range_component.in_range.connect(_on_in_range)
	if health_component:
		health_component.died.connect(queue_free)
	
	# Create PathFollow2D as a child of the path
	if path:
		path_follow = PathFollow2D.new()
		path.call_deferred("add_child", path_follow, true)
		path_follow.loop = false
		path_follow.rotates = false
		path_follow.cubic_interp = true
		# Reparent self to the PathFollow2D
		call_deferred("reparent", path_follow)
		
func _on_in_range(area: Area2D):
	if area.collision_layer & 8 != 0:
		queue_free()

func _process(delta):
	if not path_follow:
		return
	# Move along the path
	path_follow.progress += speed * delta
