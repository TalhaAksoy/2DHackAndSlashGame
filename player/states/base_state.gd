extends Node
class_name BaseState

export (String) var animation_name

var player : Player

func enter() -> void:
	player.animation.play(animation_name)

func exit() -> void:
	pass

func input(event: InputEvent) -> BaseState:
	return null

func process(delta: float) -> BaseState:
	return null

func physics_process(delta: float) -> BaseState:
	return null
