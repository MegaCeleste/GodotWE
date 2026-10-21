class_name BeachKoopaState
extends State

var koopa: BeachKoopa
var sprite: AnimatedSprite2D
var slide_comp: SlideComponent
var coll_shape: CollisionShape2D


func _init() -> void:
	intended_class = BeachKoopa


func start() -> Script:
	koopa = node
	sprite = koopa.get_node(^"%Sprite")
	slide_comp = koopa.get_node(^"%SlideComponent")
	coll_shape = koopa.get_node(^"%CollShape")
	return


func entered(player: Player) -> void:
	player.sprite.play(&"kick")
	player.spawn_spin_thump(player.global_position.lerp(koopa.global_position,
		0.5))
	player.sounds.stream = preload("uid://dcf1ixvckgpwp")
	player.sounds.play()
	koopa.kill()
