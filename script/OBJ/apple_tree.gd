extends Node2D
#No apples , apples
var  state = "no apples" 
#player state
var player_in_area = false
#load apple_collectable scene
var apple = preload("res://scene/item/apple_collectable.tscn")
#import iTem
@export_group("Item")
@export var item: InvItem
#player in area
var player= null

func _ready() -> void:
	#cooldown apple
	if state == "no apples":
		$GrowthTimer.start()

func  _process(delta: float) -> void:
	#animetion on apple tree
	if state == "no apples":
		$AnimatedSprite2D.play("no apples")
	if state == "apples":
		$AnimatedSprite2D.play("apples")
		if player_in_area:
			if Input.is_action_just_pressed("root"):
				state = "no apples" 
				dropApple() 
#check player in area 
func _on_pickable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body
#check player in out area 
func _on_pickable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
#timing cooldown apple
func _on_growth_timer_timeout() -> void:
	if state == "no apples":
		state = "apples"
#position apple drop position
func dropApple():
	var apple_instance  = apple.instantiate()
	apple_instance.global_position = $Marker2D.global_position
	get_parent().add_child(apple_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout 
	$GrowthTimer.start()
