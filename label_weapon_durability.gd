extends Label

func _process(delta: float) -> void:
	if (get_node("/root/main/Player").currentWeapon):
		text = str(get_node("/root/main/Player").currentWeapon.currentDurability)
	else:
		text = "-"
