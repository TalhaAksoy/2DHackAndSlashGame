extends BaseState
class_name MoveState

export (float) var move_speed = 200

func input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		return State.jump
