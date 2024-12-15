extends Node
class_name EquippedWeapon
# Common properties for all weapons
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
	else:
		print("The weapon can no longer be used.")

# Logic for a melee attack
func perform_melee_attack() -> void:
	print("Melee attack executed.")
