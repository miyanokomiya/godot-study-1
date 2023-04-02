extends PanelContainer

signal selected

@onready var name_label = %NameLabel
@onready var animation_player = $AnimationPlayer
@onready var hover_animation_player = $HoverAnimationPlayer

var disabled = false


func _ready():
	self.gui_input.connect(on_gui_input)
	self.mouse_entered.connect(on_mouse_entered)


func set_spell(ability: Ability):
	name_label.text = ability.name


func select_card():
	disabled = true
	animation_player.play("selected")
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
