extends Control
signal Close
signal ChooseYes

func _on_close_bt_pressed() -> void:
	Close.emit()

func _on_mine_pressed() -> void:
	global.current_scence = "Cave_mine"
	ChooseYes.emit()

func _on_monster_danger_pressed() -> void:
	global.current_scence = "Mons"
	ChooseYes.emit()

func _on_sandfighting_pressed() -> void:
	global.current_scence = "Sand_fighting"
	ChooseYes.emit()

func _on_riverget_objects_pressed() -> void:
	global.current_scence = "River_get_objects"
	ChooseYes.emit()
