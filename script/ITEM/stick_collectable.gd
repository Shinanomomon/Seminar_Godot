extends StaticBody2D
#import item
@export var item: InvItem
var player = null

func _on_interactable_area_body_entered(body: Node2D) -> void:
	#cheack player in area
	if body.has_method("player"):
		player = body
		playercollection()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollection():
	player.collect(item)
