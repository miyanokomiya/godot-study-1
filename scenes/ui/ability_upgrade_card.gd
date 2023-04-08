extends PanelContainer

signal selected

@onready var name_label = %NameLabel
@onready var description_label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var hover_animation_player = $HoverAnimationPlayer
@onready var ribbon_back = $RibbonBack
@onready var ribbon_front = $Frame/RibbonFront
@onready var crown = $Frame/Crown

var disabled = false


func _ready():
	self.gui_input.connect(on_gui_input)
	self.mouse_entered.connect(on_mouse_entered)


func play_in(delay: float = 0):
	self.modulate = Color.TRANSPARENT
	await self.get_tree().create_timer(delay).timeout
	animation_player.play("in")


func play_discard():
	animation_player.play("discard")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	
	if upgrade.rarity != 2:
		crown.hide()
	if upgrade.rarity == 0:
		ribbon_front.hide()
		ribbon_back.hide()


func select_card():
	disabled = true
	animation_player.play("selected")
	
	for other_card in self.get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		
		other_card.play_discard()
	
	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()


func on_mouse_entered():
	if disabled:
		return
	
	hover_animation_player.play("hover")
