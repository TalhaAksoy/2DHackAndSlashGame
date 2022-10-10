class_name Player
extends KinematicBody2D

export var speed = 200
export var gravity = 5
export var jump_power = 120
export var acceleration = 0.25
export var friction = 0.25
export var dash_power  = 500
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var animationTree = $AnimationTree
var state_machine
var can_dash = true
var direction = 0
var facing = "right"
var motion = Vector2()

var state
enum{
	RUN_LEFT,
	RUN_RIGHT,
	JUMP,
	DASH,
	IDLE
}


func is_facing_way():
	if facing == "left":
		sprite.flip_h = true
		direction = -1
		sprite.offset.x = -10
	else:
		sprite.flip_h = false
		sprite.offset.x = 0
		direction = 1

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	animationTree.active = true

func dash(delta):
	if is_on_floor():
		animation.playback_speed = 1
		state_machine.travel("dash")
		if facing == "left":
			direction = -1
		else:
			direction = 1
		motion.x = lerp(motion.x, direction * dash_power, acceleration)

func dash_timer():
	can_dash = false
	yield(get_tree().create_timer(0.2), "timeout")
	if state == DASH:
		state = IDLE
	yield(get_tree().create_timer(1), "timeout")
	can_dash = true

func run_left(delta):
	direction = -1
	facing = "left"
	if is_on_floor():
		state_machine.travel("run")
	motion.x = lerp(motion.x, direction * speed, acceleration)

func run_right(delta):
	direction = 1
	facing = "right"
	if is_on_floor():
		state_machine.travel("run")
	motion.x = lerp(motion.x, direction * speed, acceleration)

func jump(delta):
	state_machine.travel("jump")
	if is_on_floor():
		motion.y = -jump_power

func idle(delta):
	if is_on_floor():
		state_machine.travel("idle")
	motion.x = 0


func _physics_process(delta):
	
	var current = state_machine.get_current_node()
	is_facing_way()
	match state:
		RUN_LEFT:
			run_left(delta)
		RUN_RIGHT:
			run_right(delta)
		DASH:
			dash(delta)
		IDLE:
			idle(delta)
	if can_dash == true && Input.is_action_just_pressed("dash"):
		state = DASH
		dash_timer()
	if Input.is_action_just_pressed("left"):
		state = RUN_LEFT
	if Input.is_action_just_pressed("right"):
		state = RUN_RIGHT
	if Input.is_action_just_pressed("up"):
		jump(delta)
	if state == RUN_RIGHT && Input.is_action_just_released("right"):
		state = IDLE
	if state == RUN_LEFT && Input.is_action_just_released("left"):
		state = IDLE
	if state == DASH && Input.is_action_just_released("dash"):
		state = IDLE
	print("state = ", state)
	motion.y += gravity
	motion = move_and_slide(motion , Vector2.UP)
