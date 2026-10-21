class_name KoopaShell
extends Shell

var koopa_inside := false:
	set = _set_koopa_inside
var respawn := false
var shake_tween: Tween


func _ready() -> void:
	super()
	%ShakeTimer.start(9)
	%RespawnTimer.start(10)
	%Sprite.play(&"idle_inside" if koopa_inside else &"idle")


func shake() -> void:
	if koopa_inside:
		shake_tween = Utility.shake(%Graphics)


func _respawn_timeout() -> void:
	if not koopa_inside:
		return
	if respawn:
		var koopa = load("uid://bhbedk8m2yflb").instantiate()
		koopa.global_position = global_position
		sub_area.add(koopa)
		queue_free()
	else:
		var beach_koopa = load("uid://cefvya51l3c0q").instantiate()
		beach_koopa.global_position = global_position
		sub_area.add(beach_koopa)
		beach_koopa.stand()
		koopa_inside = false


func _set_moving(v: bool) -> void:
	%Sprite.play(&"moving" if v else
			(&"idle_inside" if koopa_inside else &"idle"))
	if shake_tween != null and shake_tween.is_valid():
		shake_tween.kill()
	%Graphics.position = Vector2.ZERO
	if v:
		%ShakeTimer.stop()
		%RespawnTimer.stop()
	else:
		%ShakeTimer.start(9)
		%RespawnTimer.start(10)
	super(v)


func _set_koopa_inside(v: bool) -> void:
	if not moving:
		%Sprite.play(&"idle_inside" if v else &"idle")
	if not v and shake_tween != null and shake_tween.is_valid():
		shake_tween.kill()
		%Graphics.position = Vector2.ZERO
	koopa_inside = v
