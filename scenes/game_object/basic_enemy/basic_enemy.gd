extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = self.get_direction_to_player()
	self.velocity = direction * MAX_SPEED
	self.move_and_slide()


func get_direction_to_player() -> Vector2:
	var player_node = self.get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - self.global_position).normalized()
	return Vector2.ZERO


func on_area_entered(other_area: Area2D):
	health_component.damage(100)
