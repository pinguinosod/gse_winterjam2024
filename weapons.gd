extends Node3D

# Common properties for all weapons
const MAX_USES: int = 10
const DURABILITY: int = 25

var uses: int = 0
var durability: int = DURABILITY

# Perform an attack
func attack() -> void:
	if uses < MAX_USES and durability > 0:
		perform_melee_attack()
		uses += 1
		durability -= 1
		print("Attack performed. Remaining uses: %d, Durability: %d" % [MAX_USES - uses, durability])
		if durability <= 0:
			queue_free()  # Remove the weapon node
			print("The weapon has broken.")
	else:
		print("The weapon can no longer be used.")

# Logic for a melee attack
func perform_melee_attack() -> void:
	print("Melee attack executed.")
