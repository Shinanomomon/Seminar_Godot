extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.game_first_loadin == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()

func _on_chiffside_trasition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scence = true

func _on_chiffside_trasition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scence = false

func change_scene():
	if global.transition_scence == true:
		if global.current_scence == "Mons":
			get_tree().change_scene_to_file("res://scene/MAP/Lab_savePoint.tscn")
			global.game_first_loadin = false
			if global.current_scence == "Mons":
				global.current_scence = "Lab_savePoint"
			global.finish_changescenes()
