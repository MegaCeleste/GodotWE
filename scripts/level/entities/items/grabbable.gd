class_name Grabbable
extends Entity
## An entity with a [PickupComponent].
## 
## A [Grabbable] is simply an entity with a [PickupComponent]. It provides
## generic throwable item behavior.

## Deceleration value.
const DECEL = 10.5
## Maximum horizontal velocity value.
const MAX_SPEED = 240.0


func _physics_process(delta: float) -> void:
	super(delta)
	if %PickupComponent.get_holder() != null:
		velocity = Vector2.ZERO
		return
	move_and_slide()
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, DECEL)
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)


func _bounced() -> void:
	velocity.x = maxf(0, absf(velocity.x) - 5.1) * signf(velocity.x)
