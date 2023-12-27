extends Area2D

var speed = 0
var swim_impulse = 150
var coasting_deceleration = 150
var velocity = Vector2.ZERO

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "swim_neutral"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = 0
	
	# Get direction player is swimming, but require a keystoke per impulse
	if Input.is_action_just_pressed("swim_up"):
		direction = 1
	if Input.is_action_just_pressed("swim_down"):
		direction = -1
	
	# Apply the swim impulse
	speed += swim_impulse * direction
	
	# Apply constant drag against movement
	if speed > coasting_deceleration * delta: 
		speed -= coasting_deceleration * delta
	elif speed < -(coasting_deceleration * delta):
		speed += coasting_deceleration * delta
	else:
		speed = 0
	
	# Calc vector and change position
	velocity = Vector2.UP * speed
	
	position += velocity * delta
	
	# Prevent flying off the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# When player hits wall, cancel all speed
	if position.y == 0 || position.y == screen_size.y:
		speed = 0
	
	if velocity.y > 0:
		$AnimatedSprite2D.animation = "swim_down"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "swim_up"
	else:
		$AnimatedSprite2D.animation = "swim_neutral"
