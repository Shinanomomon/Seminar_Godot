extends Control
#signal
signal quest_menu_closed
#queststatus
var quest1_active = false
var quset1_completed = false
var quest2_active = false
var quset2_completed = false
var stick = 0
var slime = 0

func _process(delta: float) -> void:
	if quest1_active:
		if stick == 3:
			print("quest 1 completed")
			quest1_active = false
			quset1_completed = true
			play_finish_quest_anim()
	if quest2_active:
		if slime == 2:
			print("quest 2 completed")
			quest2_active = false
			quset2_completed = true
			play_finish_quest_anim()

func play_finish_quest_anim():
	$finished_quest.visible = true
	await get_tree().create_timer(3).timeout
	$finished_quest.visible = false
	
func quest1_chat():
	$quest1_ui.visible = true

func quest2_chat():
	if quset1_completed == true:
		$quest2_ui.visible = true

func next_quest():
	if !quset1_completed:
		quest1_chat() 
	elif quset1_completed and !quset2_completed:
		quest2_chat() 
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false

func _on_yes_button_1_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = true
	stick = 0
	emit_signal("quest_menu_closed")


func _on_no_button_1_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")

func stick_collected():
	if quest1_active:
		stick += 1
		print("stick for quest")

func _on_yes_button_2_pressed() -> void:
	$quest2_ui.visible = false
	quest2_active = true
	slime = 0
	emit_signal("quest_menu_closed")

func _on_no_button_2_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")

func slime_collected():
	if quest2_active:
		slime += 1
		print("slime for quest")
