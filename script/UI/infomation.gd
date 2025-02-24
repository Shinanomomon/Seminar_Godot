extends Control
#SIGNAL
signal close
#PICTURE Periodic table
@export_group("Textures")
@export var textures: Array[Texture2D] = []
@export var textures_item: Array[Texture2D] = []
#DATA Periodic table
@export_file("res://dialogue/item_dialogue1.json") var d_file
@onready var item_visual: TextureRect = $NinePatchRect/pic_element
@onready var item_drown: TextureRect = $NinePatchRect/drown_element
#NUMBE DIALOG
var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready() -> void:
	$NinePatchRect.visible = false

func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1 
	next_script()

func load_dialogue():
	var file = FileAccess.open("res://script/dialogue/item_dialogue1.json", FileAccess.READ)
	var contents = JSON.parse_string(file.get_as_text())
	return contents

func _input(event: InputEvent) -> void:
	if  !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal('dialogue_finished')
		return 

	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']
	$NinePatchRect/source.text = "แหล่งที่มา : "+ dialogue[current_dialogue_id]['source']
	$NinePatchRect/pic_element.texture = textures[current_dialogue_id-1]
	$NinePatchRect/drown_element.texture = textures_item[current_dialogue_id-1]

func _on_close_bt_pressed() -> void:
	$NinePatchRect.visible = false
	close.emit()
