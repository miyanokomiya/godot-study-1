extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals = $Visuals


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = self.get_direction_to_player()
	self.velocity = direction * MAX_SPEED
	self.move_and_slide()
	
	var move_sign = sign(self.velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)


func get_direction_to_player() -> Vector2:
	var player_node = self.get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - self.global_position).normalized()
	return Vector2.ZERO

