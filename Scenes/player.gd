extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -500.0
var isAttacking = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("M1") and is_on_floor():
		$AnimatedSprite2D.animation = "attack"
		isAttacking = true
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not isAttacking:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction and not isAttacking:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		
	if isAttacking:
		if direction != 0:
			velocity.x = direction * SPEED
		
		
	if not isAttacking:
		if direction != 0:
			$AnimatedSprite2D.animation = "walk"
		else:
			$AnimatedSprite2D.animation = "idle"
		
	# Flip the sprite based on direction
	
	if direction != 0 and not isAttacking:
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction < 0
		
	# Make sure the animation is playing
	$AnimatedSprite2D.play()
	
	move_and_slide()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		isAttacking = false
