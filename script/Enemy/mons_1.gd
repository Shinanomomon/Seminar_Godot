extends CharacterBody2D
@export_group("MON STATUS")#MON STATUS
@export var speed = 50
@export var health = 100
@export var damageActtack:int = 30 
@export var damageArea:int = 5 #-----------
#Drop rate
@export var Rate_drop = 10
@export var Pm_drop = false
@export_group("STATUS")#STATUS
var dead = false
@export_group("PLAYER")#PLAYER
var player_in_area = false
var player 
var can_take_damage = true
@export_group("ITEM")#ITEM
@onready var bone = $bone_collectable
@onready var Pm = $Pm_collectable
@export var itemDefult: InvItem
@export var itemRes: InvItem

func _ready() -> void:
	dead = false

func _physics_process(delta: float) -> void:
	update_health()
	if !dead :
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("walk_L")
		elif !can_take_damage:
			$AnimatedSprite2D.play("hit_L")
		else:
			$AnimatedSprite2D.play("idle")
	if dead:
		$detection_area/CollisionShape2D.disabled = true

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage 
	if area.has_method("spell_deal_damage"):
		damage = area.spell_deal_damage()
		take_damage(damage)

func take_damage(damage):
	if can_take_damage == true:
		health = health - damage
		$take_damage_cooldown.start()
		can_take_damage = false
		print("mon health = ",health)
		if health <= 0 and  !dead :
			death()

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_rate()
	drop()
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true

func drop_rate():
	if(Rate_drop>= randi_range(0,100)):
		Pm_drop = true

func drop():
	bone.visible = true 
	if(Pm_drop == true):
		Pm.visible = true
		$Pm_collectable/CollisionShape2D.disabled = false
	$bone_collectable/CollisionShape2D.disabled = false
	_collect()

func _collect():
	await get_tree().create_timer(3).timeout
	bone.visible = false
	Pm.visible = false
	player.collect(itemDefult)
	if(Pm_drop == true):
		player.collect(itemRes)
	queue_free()

func enemy():
	pass

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if "get_damage" in body:
		body.get_damage(damageActtack)

func _on_mon_1_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
