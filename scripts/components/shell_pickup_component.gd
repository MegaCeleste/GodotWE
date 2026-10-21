@tool
class_name ShellPickupComponent
extends PickupComponent


func get_check_rect(_direction: int) -> Rect2:
	return check_rect.grow_side(SIDE_TOP, 5)
