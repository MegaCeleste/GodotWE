class_name DarkOverlay
extends Node2D


func _ready() -> void:
	z_index = GameConstants.Layers.Z_SOUNDS_BG
	z_as_relative = false
	hide()


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Utility.get_visible_rect(), Color("#00000098"))
