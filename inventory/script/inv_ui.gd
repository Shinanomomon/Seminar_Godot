extends Control
#load playerinv.tres
@onready var inv: Inv = preload("res://inventory/playerinv.tres")
#count slot item
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
#state bag
var isOpen = false

func _ready() -> void:
	#connect signal
	inv.update.connect(update_slots)
	update_slots()
	close()
#sort item in slot
func update_slots():
	for i  in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta: float) -> void:
	# state bag
	if Input.is_action_just_pressed("bag"):
		if isOpen:
			close()
		else :
			open()
#state bag open
func open():
	visible = true
	isOpen = true
#state bag close
func close():
	visible = false
	isOpen = false
