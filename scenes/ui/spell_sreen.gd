extends CanvasLayer

signal spell_selected(ability: Ability)

var spell_card_scene = preload("res://scenes/ui/spell_card.tscn")

@onready var card_container = %CardContainer
@onready var animation_player = $AnimationPlayer


func _ready():
	self.get_tree().paused = true


func set_spells(abilities: Array[Ability]):
	for c in card_container.get_children():
		card_container.remove_child(c)
		
	for ability in abilities:
		var card = spell_card_scene.instantiate()
		card_container.add_child(card)
		card.set_spell(ability)
		card.selected.connect(on_spell_selected.bind(ability))


func on_spell_selected(ability: Ability):
	spell_selected.emit(ability)
	animation_player.play("out")
	await animation_player.animation_finished
	self.get_tree().paused = false
	self.queue_free()
