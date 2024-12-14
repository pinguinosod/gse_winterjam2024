extends Node3D

# Common properties for all weapons
const maxDurability: int = 25
var currentDurability: int = maxDurability

# Perform an attack
func attack() -> void:
	if currentDurability > 0:
		perform_melee_attack()
		currentDurability -= 1
		print("Attack performed. Remaining durability: %d" % [currentDurability])
		if currentDurability <= 0:
			queue_free()  # Remove the weapon node
			print("The weapon has broken.")
	else:
		print("The weapon can no longer be used.")

# Logic for a melee attack
func perform_melee_attack() -> void:
	print("Melee attack executed.")
