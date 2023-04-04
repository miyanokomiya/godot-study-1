extends BoxContainer

@onready var icon_texture_rect = %IconTextureRect
@onready var quantity_label = %QuantityLabel


func set_status_effect(effect: StatusEffect):
	icon_texture_rect.texture = effect.icon
	quantity_label.text = "x%d" % effect.quantity
