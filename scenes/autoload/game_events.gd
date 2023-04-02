extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager)
signal player_damaged

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, upgrade_manager: UpgradeManager):
	ability_upgrade_added.emit(upgrade, upgrade_manager)



func emit_player_damaged():
	player_damaged.emit()
