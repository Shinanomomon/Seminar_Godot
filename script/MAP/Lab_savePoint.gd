extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	change_scene()

func _on_home_exitpoint_body_entered(body: Node2D) -> void:
	if body.has_method("player") && global.choose_state:
		global.transition_scence = true

func _on_home_exitpoint_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scence = false

func change_scene():
	if global.transition_scence == true:
		if global.current_scence == "River_get_objects":
			global.choose_state = false
			get_tree().change_scene_to_file("res://scene/MAP/River_get_objects.tscn")
			global.finish_changescenes()
		elif global.current_scence == "Sand_fighting":
			global.choose_state = false
			get_tree().change_scene_to_file("res://scene/MAP/Sand_fighting.tscn")
			global.finish_changescenes()
		elif global.current_scence == "Mons":
			global.choose_state = false
			get_tree().change_scene_to_file("res://scene/MAP/Mons.tscn")
			global.finish_changescenes()
		elif global.current_scence == "Cave_mine":
			global.choose_state = false
			get_tree().change_scene_to_file("res://scene/MAP/Cave_mine.tscn")
			global.finish_changescenes()

func _on_choose_map_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		$player.Animataed_open_ui()
		$player/Change_map_UI.visible = true
