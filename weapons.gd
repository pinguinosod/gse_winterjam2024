extends Node
class_name EquippedWeapon
var maxDurability: int = 25
var currentDurability: int = maxDurability
var movementCost: int = 1

# Perform an attack
func attack() -> void:
	if currentDurability > 0:
		perform_melee_attack()
		currentDurability -= 1
		print("Attack performed. Remaining durability: %d" % [currentDurability])
		if currentDurability <= 0:
			print("The weapon has broken.")
			Engine.get_main_loop().current_scene.get_node("/root/main/UI/HUDPanel/GridContainer/Equipment/LabelWeaponName").text = "-"
			if Engine.get_main_loop().current_scene.get_node("/root/main/Player").itemColliding != null:
				Engine.get_main_loop().current_scene.get_node("/root/main/UI/HUDPanel/GridContainer/PickupItemButton").disabled = false
			Engine.get_main_loop().current_scene.get_node("/root/main/Player").currentWeapon = null
			queue_free()
	else:
		print("The weapon can no longer be used.")

# Logic for a melee attack
func perform_melee_attack() -> void:
	print("Melee attack executed.")
