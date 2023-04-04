extends Resource
class_name StatusEffect

enum StatusEffectType { BUFF, DEBUFF }

@export var id: String
@export var name: String
@export_multiline var description: String
@export var type: StatusEffectType = StatusEffectType.BUFF
@export var quantity: int = 1
