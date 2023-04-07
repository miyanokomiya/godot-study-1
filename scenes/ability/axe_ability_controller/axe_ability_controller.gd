extends AbilityController

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer

var base_damage = 9.0
var wait_time = 3.0


func _ready():
	timer.timeout.connect(on_timer_timeout)
	timer.wait_time = wait_time
	timer.start()
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func proc_ability():
	var player = self.get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = self.get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in self.quantity:
		var axe_ability_scene_instance = axe_ability_scene.instantiate() as Node2D
		foreground.add_child(axe_ability_scene_instance)
		axe_ability_scene_instance.base_rotation = base_rotation.rotated(TAU / self.quantity * i)
		axe_ability_scene_instance.base_rotation_range = TAU / ceil(self.quantity / 2.0)
		axe_ability_scene_instance.global_position = player.global_position
		axe_ability_scene_instance.hitbox_component.damage = self.base_damage + self.additional_damage
		self.decorate_ability(axe_ability_scene_instance)


func on_timer_timeout():
	proc_ability()
	self.decorate_on_timeout()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	if upgrade.id == "axe_damage":
		self.increase_damage(1)
