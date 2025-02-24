extends Resource
#class_name and child_node Resource
class_name Inv
#signal
signal frist_get
signal update
#importt InvSlot
@export var slots:Array[InvSlot]
#count item sent signalupdate
func  insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)#-->check itemslot is resemble
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null) #-->check itemslot is null 
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
			frist_get.emit()
	update.emit()
