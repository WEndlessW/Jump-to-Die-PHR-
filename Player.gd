extends KinematicBody2D

var velocity = Vector2.ZERO

export(int) var JUMP_FORCE = -150
export(int) var JUMP_RELEASE_FORCE = -75
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 5
export(int) var PLUS_GRAVITY_FALL_SPEED = 2

onready var AUDIOSTREAMPLAYER = $AudioStreamPlayer 

func _physics_process(delta):
	gravitation()
	
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("ui_up"):
		AUDIOSTREAMPLAYER.play()
	
	if input.x > 0:
		$AnimatedSprite.animation = "Right"
		if input.x > 0 and not is_on_floor():
			$AnimatedSprite.animation = "In_Jump"
		
	if input.x < 0:
		$AnimatedSprite.animation = "Left"
		if input.x < 0 and not is_on_floor():
			$AnimatedSprite.animation = "L_In_Jump"
	
	
	
	
	if input.x == 0:
		$AnimatedSprite.animation = "Idle"
		apply_friction()
	else:
		apply_acceleration(input.x)
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += PLUS_GRAVITY_FALL_SPEED
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func gravitation():
	velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0 , FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

