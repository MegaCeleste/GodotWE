class_name Entity
extends CharacterBodyExt
## Represents any character body in the stage.

## A reference to the level this entity is in.
var level: Level
## A refrence to the sub-area this entity is in.
var sub_area: SubArea

## The node that holds this entity's graphics.
@onready var graphics: Node2D = $Graphics


## Kills this entity. [param killer] must be provided, as some death behaviors
## rely on knowing certain properties of it. Returns the dead version of this
## entity, if any.
func kill(killer: Node2D) -> Node2D:
	graphics.reparent(get_parent())
	graphics.set_script(DeadEntity)
	if killer.global_position.x > global_position.x:
		graphics.velocity.x = -60
	else:
		graphics.velocity.x = 60
	queue_free()
	return graphics


## Handles this entity getting hit from the bottom via a container tile (i.e.
## a [Node2D] with a [BlockComopnent]). Kills this entity by default.
@warning_ignore("unused_parameter")
func block_hit(block: Node2D, hitter: Entity) -> void:
	kill(hitter)
