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
	velocity = Vector2.UP * speed

	position += velocity * delta

	# Prevent flying off bottom of screen
	position = position.clamp(Vector2.ZERO, screen_size)

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
	hide() # Disappear after being hit
	hit.emit()
	$Hitbox.set_deferred("disabled", true)

func start(pos):
	position = pos
	speed = 0
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
