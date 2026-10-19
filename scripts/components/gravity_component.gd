@icon("uid://bsp0i5axp4cgp")
class_name GravityComponent
extends Component
## Provides customizable gravity.

## Emitted when the body bounces.
signal bounced

## The gravity. By default, this is the [code]default_gravity[/code] project
## setting multiplied by the [code]default_gravity_vector[/code].
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s²")
var gravity: Vector2 = default()
## The maximum fall speed.
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s")
var max_fall_speed := 258.0
## Whether the body will bounce on landing.
@export var bounce := false
## Multiplier of the downward velocity for how strong the bounce will be. This
## shouldn't be negative because it is already negated in processing. Making
## this 1 will result in just as much velocity going up as it was going down,
## bouncing forever and reaching the starting height.
@export var bounce_strength := 0.5
## The minimum velocity for the body to bounce.
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s")
var minimum_bounce_velocity := 30

## The body's velocity value last frame, before the gravity was applied.
var old_velocity: Vector2


## Returns the default gravity value from the project settings as a vector.
static func default() -> Vector2:
	return (
		ProjectSettings.get_setting("physics/2d/default_gravity_vector")
		* ProjectSettings.get_setting("physics/2d/default_gravity")
	)


func _physics_process(_delta: float) -> void:
	var p = get_parent() as CharacterBody2D
	if p == null:
		return
	if will_bounce():
		p.velocity.y = old_velocity.y * -bounce_strength
		bounced.emit()
	old_velocity = p.velocity
	p.velocity += gravity
	if p.velocity.y > max_fall_speed:
		p.velocity.y = max_fall_speed


## Whether the parent body will bounce, based on the current circumstances.
func will_bounce() -> bool:
	return get_parent().is_on_floor() and bounce \
			and old_velocity.y > minimum_bounce_velocity
