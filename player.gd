extends Area2D

signal hit

var speed = 0
var acceleration = 15
var coasting_deceleration = 150
var air_gravity = 400
var velocity = Vector2.ZERO

var in_air = false

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "swim_neutral"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = 0
	

	if in_air:
		speed -= air_gravity * delta
	# Get direction player is swimming, but require a keystoke per impulse
	else:
		if Input.is_action_pressed("swim_up"):
			direction = 1
		if Input.is_action_pressed("swim_down"):
			direction = -1
		# Apply the swim impulse
		speed += acceleration * direction
		
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
	
	# Prevent flying off bottom of screen
	position = position.clamp(Vector2.ZERO, screen_size)

	# When player hits bottom, cancel all speed
	if position.y == 480:
		speed = 0
	
	if velocity.y > 0:
		$AnimatedSprite2D.animation = "swim_down"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "swim_up"
	else:
		$AnimatedSprite2D.animation = "swim_neutral"


func _on_body_entered(body):
	hide() # Disappear after being hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_area_entered(area):
	if (area.name == 'Air'):
		in_air = true

func _on_area_exited(area):
	if (area.name == 'Air'):
		in_air = false
