extends Resource
class_name StatusEffect

enum StatusEffectType { BUFF, DEBUFF }

signal quantity_changed

@export var id: String
@export var name: String
@export_multiline var description: String
@export var type: StatusEffectType = StatusEffectType.BUFF
@export var icon: Texture
@export var quantity: int = 1


func set_quantity(value: int):
	quantity = value
	quantity_changed.emit()
