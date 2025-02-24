extends CharacterBody2D
#SLIME STATUS
@export var speed = 20 
@export var health = 100
@export var damageActtack:int = 10 
#STTATUS
var dead = false
#PLAYER
var player_in_area = false
var player 
var can_take_damage = true
#ITEM
@onready var slime = $slime_collectable
@export var itemRes: InvItem

func _ready() -> void:
	dead = false

func _physics_process(delta: float) -> void:
	update_health()
	if !dead :
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
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
		print("slime health = ",health)
		if health <= 0 and  !dead :
			death()

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_slime()
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true

func drop_slime():
	slime.visible = true
	$slime_collect_area/CollisionShape2D.disabled = false
	slime_collect()

func slime_collect():
	await get_tree().create_timer(1.5).timeout
	slime.visible = false
	player.collect(itemRes)
	queue_free()

func _on_slime_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body

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
