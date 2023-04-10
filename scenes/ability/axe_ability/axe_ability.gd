extends SpellAbility

@onready var hitbox_component = $HitboxComponent
@onready var orbit_component = $OrbitComponent

var base_rotation = Vector2.RIGHT
var base_rotation_range = TAU
var base_position = Vector2(200, 100)


func _ready():
	orbit_component.finished.connect(self.queue_free)


func start():
	global_position = base_position + base_rotation * 5
	orbit_component.duration = 2.0
	orbit_component.total_rotation_rate = base_rotation_range / TAU
	
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player:
		orbit_component.start(player)
	else:
		orbit_component.start(null, base_position)
