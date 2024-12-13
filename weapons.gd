extends Node3D

# Maximum number of uses before the weapon is destroyed
const MAX_USES: int = 10

# Counter for the number of uses
var uses: int = 0

# Called to perform an attack
func attack() -> void:
	if uses < MAX_USES:
		perform_melee_attack()
		uses += 1
		print("Attack performed. Remaining uses: %d" % (MAX_USES - uses))
		if uses >= MAX_USES:
			queue_free()  # Removes the weapon node
			print("The weapon has been destroyed.")
	else:
		print("The weapon can no longer be used.")

# Melee attack logic
func perform_melee_attack() -> void:
	# Add collision, damage, or other logic here
	print("Melee attack executed.")


#??????cLASS FOR Player???
# Reference to the equipped weapon
var equipped_weapon: Node3D = null

# Called when the player attacks
func perform_attack() -> void:
	if equipped_weapon:
		equipped_weapon.attack()
	else:
		print("No weapon equipped.")
