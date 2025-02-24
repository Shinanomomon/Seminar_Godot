extends Node2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	change_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scence = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scence = false

func change_scene():
	if global.transition_scence == true:
		if global.current_scence == "Sand_fighting":
			get_tree().change_scene_to_file("res://scene/MAP/Lab_savePoint.tscn")
			global.game_first_loadin = false
			if global.current_scence == "Sand_fighting":
				global.current_scence = "Lab_savePoint"
			global.finish_changescenes()
