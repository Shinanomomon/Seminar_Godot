extends CharacterBody2D
#signal
signal stick_collected
signal apple_collected
signal slime_collected
@export_group("Player")
var enemy_inattack_range = false
var enemy_attack_cooldown = true
@export var health = 100
@export var maxhealth = 100
var player_alive = true
var Damage_enemy_acttack = 0
#speed player
@export var speed = 100
#player_state 
var player_state
#load slots item
@export_group("Bag")
@export var inv:Inv
#load weapon
var  spell_equiped = false
var spell_cooldown = true
var spell = preload("res://scene/OBJ/spell.tscn")
#load position mouse
var mouse_loc_from_player = null
var Enemy

func _ready() -> void:
	inv.frist_get.connect(Frist_item)
	$infomation.hide()
	$Change_map_UI.visible = false

func  _physics_process(delta):
	#get position mouse - player position
	mouse_loc_from_player = get_global_mouse_position() - self.position
	#get input walk
	var direction = Input.get_vector("left", "right", "down", "up")
	#player_state is idle or walking
	if !global.statuswalk:
		return
	if direction.x == 0 and direction.y == 0 :
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	#speed
	velocity = direction * speed
	#show
	move_and_slide()
	#equiped weapon state
	if Input.is_action_just_pressed("equiped_weapon"):
		if spell_equiped:
			spell_equiped = false
		else: 
			spell_equiped = true
	#direction weapon
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	#state counter
	if Input.is_action_just_pressed("left_mouse") and spell_equiped and spell_cooldown :
		spell_cooldown = false
		var spell_instance = spell.instantiate()
		spell_instance.rotation = $Marker2D.rotation
		spell_instance.global_position = $Marker2D.global_position
		add_child(spell_instance)
		#weapon cooldown
		await get_tree().create_timer(0.4).timeout
		spell_cooldown = true
	#animetion player
	play_anim(direction)
	enemy_attack()
	current_camera()
	update_health()
	#Sttatus Health Player
	if health <= 0:
		player_alive = false #go respond
		health = 0
		print("player has been killed")
		self.queue_free()

func play_anim(dir):
	#animetion player walk a s w d
	if !spell_equiped:
		speed = 100
		if player_state == "idle" : 
			$AnimatedSprite2D.play("idle")
		if player_state == "walking" : 
			if dir.y == -1 :
				$AnimatedSprite2D.play("r-walk")
			if dir.x == 1 :
				$AnimatedSprite2D.play("r-walk")
			if dir.x == -1 :
				$AnimatedSprite2D.play("l-walk")
			if dir.y == 1 :
				$AnimatedSprite2D.play("l-walk")
			#animetion player silde 
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("r-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("r-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("l-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("l-walk")
	#animetion player attack 
	if spell_equiped:
		speed = 0
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0 :
			$AnimatedSprite2D.play("r-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0 :
			$AnimatedSprite2D.play("r-attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0 :
			$AnimatedSprite2D.play("l-attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0 :
			$AnimatedSprite2D.play("l-attack")
	#animetion player attack silde 
		if  mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("r-attack")
		if  mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("r-attack")
		if  mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("l-attack")
		if  mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("l-attack")
#Call Player
func player():
	pass
#root item
func collect(item):
	inv.insert(item)
	if str(item.name) == "stick": #stick
		emit_signal("stick_collected")
	if str(item.name) == "slime": #slime
		emit_signal("slime_collected")
	if str(item.name) == "apple": #apple
		emit_signal("apple_collected")

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		Enemy = body
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - Damage_enemy_acttack
		enemy_attack_cooldown = false
		$attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown =true

func current_camera():
	if global.current_scence == "Mons":
		$Mons_camera.enabled = true
		$Cave_mine_camera.enabled = false
		$Lab_savePoint_camera.enabled = false
		$River_get_objects_camera.enabled = false
		$Sand_fighting_camera.enabled = false
	elif global.current_scence == "Lab_savePoint":
		$Mons_camera.enabled = false
		$Cave_mine_camera.enabled = false
		$Lab_savePoint_camera.enabled = true
		$River_get_objects_camera.enabled = false
		$Sand_fighting_camera.enabled = false
	elif global.current_scence == "River_get_objects":
		$Mons_camera.enabled = false
		$Cave_mine_camera.enabled = false
		$Lab_savePoint_camera.enabled = false
		$River_get_objects_camera.enabled = true
		$Sand_fighting_camera.enabled = false
	elif global.current_scence == "Sand_fighting":
		$Mons_camera.enabled = false
		$Cave_mine_camera.enabled = false
		$Lab_savePoint_camera.enabled = false
		$River_get_objects_camera.enabled = false
		$Sand_fighting_camera.enabled = true
	elif global.current_scence == "Cave_mine":
		$Mons_camera.enabled = false
		$Cave_mine_camera.enabled = true
		$Lab_savePoint_camera.enabled = false
		$River_get_objects_camera.enabled = false
		$Sand_fighting_camera.enabled = false

func Frist_item():
	$infomation.show()
	$infomation.visible = true
	Animataed_open_ui()
	$infomation.start()

func _on_infomation_close() -> void:
	$infomation.hide()
	Animataed_close_ui()

func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= maxhealth:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_timer_timeout() -> void:
	if health < maxhealth:
		health =  health + 20
		if health > maxhealth:
			health = maxhealth
	if health <= 0:
		health = 0

func get_damage(amount):
	Damage_enemy_acttack = amount

func _on_change_map_ui_close() -> void:
	$Change_map_UI.visible = false
	global.choose_state = false
	Animataed_close_ui()

func _on_change_map_ui_choose_yes() -> void:
	$Change_map_UI.visible = false
	global.choose_state = true
	Animataed_close_ui()

func Animataed_open_ui() -> void:
	global.statuswalk = false
	$AnimatedSprite2D.visible = false

func Animataed_close_ui() -> void:
	global.statuswalk = true
	$AnimatedSprite2D.visible = true
