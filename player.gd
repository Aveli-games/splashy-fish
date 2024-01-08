extends Area2D

signal hit


const MAX_SPEED = 800
const MAX_ROTATION = PI / 3 # 60 degrees

var speed = 0
var acceleration = 1800
var coasting_deceleration = 600
var air_gravity = 1000
var velocity = Vector2.ZERO

var in_air = false

# x-speed stuff mainly for animating fish in/out
const SWIM_IN_SPEED = 100
const HIT_SPEED = -400
var x_speed = 0
var x_max = 200

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "swim_neutral"
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = 0

	# use x direction for animation
	if position.x > x_max:
		position.x = x_max
		x_speed = 0
	if position.x < -100 && x_speed < 0:
		x_speed = 0
		hide()


	if in_air:
		speed -= air_gravity * delta
	# Get direction player is swimming, but require a keystoke per impulse
	else:
		if Input.is_action_pressed("swim_up"):
			direction = 1
		if Input.is_action_pressed("swim_down"):
			direction = -1
		# Apply the swim impulse if onscreen
		if position.x > 0:
			speed += acceleration * delta * direction

		# Apply constant drag against movement if no direction input
		if not direction:
			if speed > coasting_deceleration * delta:
				speed -= coasting_deceleration * delta
			elif speed < -(coasting_deceleration * delta):
				speed += coasting_deceleration * delta
			else:
				speed = 0
	# Calc vector and change position
	velocity = Vector2(x_speed, -speed)

	position += velocity * delta

	# Prevent flying off bottom of screen
	position.y = clamp(position.y, 0, screen_size.y)

	# When player hits bottom, cancel all speed
	if position.y == screen_size.y:
		speed = 0
	else:
		speed = clamp(speed, -MAX_SPEED, MAX_SPEED)

	# Sprite animation based on direction of player input (neutral in air)
	if direction < 0 && not in_air:
		$AnimatedSprite2D.animation = "swim_down"
	elif direction > 0 && not in_air:
		$AnimatedSprite2D.animation = "swim_up"
	else:
		$AnimatedSprite2D.animation = "swim_neutral"

	# Rotation based on percentage of max speed reached
	rotation = -MAX_ROTATION * (speed / MAX_SPEED)


func _on_body_entered(_body):
	x_speed = HIT_SPEED
	hit.emit()
	$Hitbox.set_deferred("disabled", true)

func start(pos):
	x_max = pos.x
	position = Vector2(-2*SWIM_IN_SPEED, pos.y)
	speed = 0
	x_speed = SWIM_IN_SPEED
	show()
	# Give 1 second of invulnerability at start to account for any old obstacles
	await get_tree().create_timer(1.0).timeout
	$Hitbox.disabled = false

func _on_area_entered(area):
	if (area.name == 'Air'):
		in_air = true

func _on_area_exited(area):
	if (area.name == 'Air'):
		in_air = false
