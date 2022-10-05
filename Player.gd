extends KinematicBody2D

export var speed = 200
export var gravity = 5
export var jump_power = 120
export var acceleration = 0.25
export var friction = 0.25
export var dash_power  = 1000
onready var animated_sprite = $AnimatedSprite
var direction = 0
var facing
var motion = Vector2.ZERO

func dash():
	if Input.is_action_just_pressed("dash"):
		if is_on_floor():
			if facing == "left":
				direction = -1
			else:
				direction = 1
			if direction == 1:
				animated_sprite.flip_h = false
				animated_sprite.animation = "dash"
			else:
				animated_sprite.flip_h = true
				animated_sprite.animation = "dash"
			motion.x +=  direction * dash_power
	animated_sprite.update()


func get_direciton():
	# Horizontal
	direction = 0
	if Input.is_action_pressed("left"):
		direction = -1
		facing = "left"
		if is_on_floor():
			animated_sprite.animation = "run"
			animated_sprite.flip_h = true
	if Input.is_action_pressed("right"):
		direction = 1
		facing = "right"
		if is_on_floor():
			animated_sprite.animation = "run"
			animated_sprite.flip_h = false
	if direction == 0:
		if facing == "left":
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		if is_on_floor() && !animated_sprite.animation.match("dash"):
			animated_sprite.animation = "idle"
		motion.x = lerp(motion.x, 0, friction)
	else:
		motion.x = lerp(motion.x, direction * speed, acceleration)
	#Jump
	if Input.is_action_just_pressed("up"):
		animated_sprite.animation = "jump"
		if is_on_floor():
			motion.y = -jump_power

func _physics_process(delta):
	
	get_direciton()
	dash()
	print("motion = ",motion.x," motion.y = ",motion.y," direction = ",direction)	
	motion.y += gravity
	motion = move_and_slide(motion , Vector2.UP)
	
