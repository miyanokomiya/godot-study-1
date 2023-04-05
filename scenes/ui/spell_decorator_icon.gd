extends BoxContainer

@onready var icon_texture_rect = %IconTextureRect


func set_decorator(resource: SpellDecoratorResource):
	icon_texture_rect.texture = resource.icon
