extends Area2D
#WEAPON STATUS
@export var speed = 300
@export var damage = 50

func _ready() -> void:
	#set position
	set_as_top_level(true)

func spell_deal_damage():
	return damage

func _physics_process(delta: float) -> void:
	#caculate speed
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

#out screen
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
