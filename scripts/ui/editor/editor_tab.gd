class_name EditorTab
extends TextureRect

const ERASE_COLOR = Color("#2592f2")
const ERASE_TEXT = &"EDITOR_ERASE"
const OTHER_COLOR = Color("#946232")
const SOUNDS_TEXT = &"EDITOR_SOUNDS"

@onready var left_offset = global_position.x


func _process(_delta: float) -> void:
	global_position.x = %LeftPanel.get_rect().end.x + left_offset
	
	if %Editor.erasing != Editor.EraseMode.NONE:
		show()
		self_modulate = ERASE_COLOR
		%TabText.text = ERASE_TEXT
	elif %Editor.part_type == Editor.PartType.SOUNDS:
		show()
		self_modulate = OTHER_COLOR
		%TabText.text = SOUNDS_TEXT
	else:
		hide()
