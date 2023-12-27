extends Area2D

var speed = 0
var swim_impulse = 30
var coasting_deceleration = 150
var velocity = Vector2.ZERO

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = 0
	
	# Get direction player is swimming
	if Input.is_action_pressed("swim_up"):
		direction = 1
	if Input.is_action_pressed("swim_down"):
		direction = -1
	
	# Apply the swim impulse
	speed += swim_impulse * direction
	
	# Apply constant drag against movement
	if speed > 0: 
		speed -= coasting_deceleration * delta
	elif speed < 0:
		speed += coasting_deceleration * delta
	
	# Calc vector and change position
	velocity = Vector2.UP * speed
	
	position += velocity * delta
	
	# Prevent flying off the screen
	position = position.clamp(Vector2.ZERO, screen_size)
