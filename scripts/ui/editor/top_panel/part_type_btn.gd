class_name PartTypeBtn
extends BaseButton

const PRESS_SOUND = preload("uid://dyyn2nvxnwepp")
const BTN_OBJECTS = preload("uid://cjt6vqgprv8fg")
const BTN_OBJECTS_BLINK = preload("uid://b2v0fhgpg8w8x")
const BTN_SOUNDS = preload("uid://bm1dqxydc2yy7")
const BTN_SOUNDS_OPEN = preload("uid://cghxg8d80ngy")
const QUAVER = preload("uid://dj3wb3bwkypgx")
const DOUBLE_QUAVER = preload("uid://p7m6sps4hjc1")

var timer := Timer.new()
var sounds := AudioStreamPlayer.new()

var _tween: Tween
var _texture: Texture2D:
	set = _set_texture
var _quaver_pos := Vector2.INF:
	set = _set_quaver_pos
var _double_quaver_pos := Vector2.INF:
	set = _set_double_quaver_pos

@onready var effect := ButtonHoverEffect.new(self)


func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	%Editor.part_type_changed.connect(_part_type_changed)
	
	sounds.name = "Sounds"
	add_child(sounds)
	timer.name = "AnimationTimer"
	timer.one_shot = true
	add_child(timer)
	
	_part_type_changed()


func _process(_delta: float) -> void:
	effect.check_redraw()
	if _tween != null and _tween.is_valid():
		queue_redraw()


func _draw() -> void:
	if _texture != null:
		draw_texture(_texture, Vector2(0, 0))
	draw_texture(QUAVER, _quaver_pos)
	draw_texture(DOUBLE_QUAVER, _double_quaver_pos)
	effect.draw()


func _pressed() -> void:
	sounds.stream = PRESS_SOUND
	sounds.play()
	print(%Editor.part_type)
	%Editor.part_type = (%Editor.part_type + 1) % Editor.PartType.size()
	print(%Editor.part_type)


func _mouse_entered() -> void:
	effect.start()


func _mouse_exited() -> void:
	effect.stop()


func _part_type_changed() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.set_loops()
	
	match %Editor.part_type:
		
		Editor.PartType.OBJECTS:
			_quaver_pos = Vector2.INF
			_double_quaver_pos = Vector2.INF
			
			_tween.tween_callback(func(): _texture = BTN_OBJECTS)
			_tween.tween_callback(func(): timer.start(randf_range(2, 4)))
			_tween.tween_await(timer.timeout)
			
			_tween.tween_callback(func(): _texture = BTN_OBJECTS_BLINK)
			_tween.tween_interval(1/6.0)
		
		Editor.PartType.SOUNDS:
			_tween.tween_callback(func(): _texture = BTN_SOUNDS)
			_tween.tween_interval(1/9.0)
			
			_tween.tween_callback(func(): _texture = BTN_SOUNDS_OPEN)
			_tween.tween_property(self, "_quaver_pos", Vector2(-3, -3), 3/9.0) \
					.from(Vector2(0, 3))
			_tween.tween_property(self, "_quaver_pos", Vector2.INF, 0)
			_tween.tween_property(self, "_double_quaver_pos", Vector2(51, 0),
					3/9.0).from(Vector2(45, 6))
			_tween.tween_property(self, "_double_quaver_pos", Vector2.INF, 0)


func _set_texture(v: Texture2D) -> void:
	_texture = v
	queue_redraw()


func _set_quaver_pos(v: Vector2) -> void:
	_quaver_pos = v
	queue_redraw()


func _set_double_quaver_pos(v: Vector2) -> void:
	_double_quaver_pos = v
	queue_redraw()
