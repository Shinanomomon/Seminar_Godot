extends Node

var player_current_attack = false

var player_exit_cliffside_posx = 0
var player_exit_cliffside_posy = 0
var player_start_posx = 4
var player_start_posy = -14
var statuswalk = true

var game_first_loadin = true
#finish_changescenes
var current_scence = "Lab_savePoint" #Lab_savePoint cliff_side
var transition_scence = false
var choose_state = false
func finish_changescenes():
	if transition_scence == true:
		transition_scence = false
