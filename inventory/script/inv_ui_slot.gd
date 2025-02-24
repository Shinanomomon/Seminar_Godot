extends Panel
#load one slot
@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
#update slot in one slot
func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else :
		item_visual.visible = true
		item_visual.texture = slot.item.textuer
		amount_text.visible = true
		amount_text.text = str(slot.amount)
