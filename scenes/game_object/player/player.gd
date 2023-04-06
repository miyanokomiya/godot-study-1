extends CharacterBody2D

@export var arena_time_manager: Node

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hit_random_stream_player = $HitRandomStreamPlayer
@onready var sprite_2d = $Visuals/Sprite2D

var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	arena_time_manager.arena_dificulty_increased.connect(on_arena_dificulty_increased)
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement_vector = self.get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_decreased(diff: float):
	GameEvents.emit_player_damaged()
	hit_random_stream_player.play_random()


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		if abilities.has_node(ability.id):
			abilities.get_node(ability.id).increase_quantity(1)
		else:
			var controller = ability.ability_controller_scene.instantiate() as AbilityController
			controller.name = ability.id
			abilities.add_child(controller)
			controller.apply_current_upgrades(upgrade_manager)
			
			var ability_status_screen = self.get_tree().get_first_node_in_group("ability_status_screen")
			if ability_status_screen:
				ability_status_screen.add_status_card(controller)
	elif ability_upgrade is AbilityDecorator:
		var target_ids = upgrade_manager.current_upgrades[ability_upgrade.id]["decorate_targets"].keys()
		for target_id in target_ids:
			if abilities.has_node(target_id):
				var decorator = (ability_upgrade as AbilityDecorator).decorator_controller.instantiate() as AbilityControllerDecorator
				abilities.get_node(target_id).add_decorator(decorator)
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * upgrade_manager.get_upgrade_quantity("player_speed") * 0.1)


func on_arena_dificulty_increased(arena_dificulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if health_regeneration_quantity >0:
		var is_thirty_second_interval = (arena_dificulty % 6) == 0
		if is_thirty_second_interval:
			health_component.heal(health_regeneration_quantity)
