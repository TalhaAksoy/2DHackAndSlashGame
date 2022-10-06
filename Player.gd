extends KinematicBody2D

export var speed = 200
export var gravity = 5
export var jump_power = 120
export var acceleration = 0.25
export var friction = 0.25
export var dash_power  = 1000
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
var state_machine
var direction = 0
var facing = "right"
var motion = Vector2.ZERO

func dash():
	if Input.is_action_just_pressed("dash"):
		animation.playback_speed = 1
		state_machine.travel("dash")
		if is_on_floor():
			if facing == "left":
				direction = -1
			else:
				direction = 1
			motion.x +=  direction * dash_power

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

func get_direciton():
	# Horizontal
	var current = state_machine.get_current_node()
	direction = 0
	if Input.is_action_pressed("left"):
		direction = -1
		facing = "left"
		if is_on_floor():
			animation.playback_speed = 1.5
			state_machine.travel("run")
	if Input.is_action_pressed("right"):
		direction = 1
		facing = "right"
		if is_on_floor():
			animation.playback_speed = 1.5
			state_machine.travel("run")
	if direction == 0:
		if is_on_floor():
			animation.playback_speed = 0.8
			state_machine.travel("idle")
		motion.x = lerp(motion.x, 0, friction)
	else:
		motion.x = lerp(motion.x, direction * speed, acceleration)
	#Jump
	if Input.is_action_just_pressed("up"):
		animation.playback_speed = 1
		state_machine.travel("jump")
		if is_on_floor():
			motion.y = -jump_power

func _physics_process(delta):
	
	is_facing_way()
	get_direciton()
	dash()
	print("motion = ",motion.x," motion.y = ",motion.y," direction = ",direction)	
	motion.y += gravity
	motion = move_and_slide(motion , Vector2.UP)
