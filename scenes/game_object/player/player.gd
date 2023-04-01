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
@onready var dash_component = $DashComponent
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
	if Input.is_action_just_pressed("dash"):
		dash_component.start_dash(sprite_2d, 0.2)
	
	var movement_vector = self.get_movement_vector()
	var direction = movement_vector.normalized()
	
	if dash_component.is_dashing():
		velocity_component.accelerate_in_direction(direction * 2, true)
	else:
		velocity_component.accelerate_in_direction(direction)
	
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
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


func on_health_decreased():
	GameEvents.emit_player_damaged()
	hit_random_stream_player.play_random()


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		if abilities.has_node(ability.id):
			abilities.get_node(ability.id).increase_quantity(1)
		else:
			var instance = ability.ability_controller_scene.instantiate() as Node
			instance.name = ability.id
			abilities.add_child(instance)
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)


func on_arena_dificulty_increased(arena_dificulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if health_regeneration_quantity >0:
		var is_thirty_second_interval = (arena_dificulty % 6) == 0
		if is_thirty_second_interval:
			health_component.heal(health_regeneration_quantity)
