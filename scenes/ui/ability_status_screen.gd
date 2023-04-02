extends CanvasLayer

var ability_status_card = preload("res://scenes/ui/ability_status_card.tscn")

@onready var card_container = %CardContainer


func _ready():
	for c in card_container.get_children():
		card_container.remove_child(c)


func add_status_card(controller: AbilityController):
	var card = ability_status_card.instantiate()
	card_container.add_child(card)
	card.set_ability_controller(controller)
