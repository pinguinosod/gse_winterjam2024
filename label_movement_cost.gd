extends Label

func _process(delta: float) -> void:
	if (get_node("/root/main/Player").currentWeapon):
		text = str(get_node("/root/main/Player").currentWeapon.movementCost + 1)
	else:
		text = "1"
