extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()

func show_timed_message(text, time):
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = time
	$MessageTimer.start()

func show_game_over(time):
	show_timed_message("Game Over", time)

	$StartButton.show()

	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	if $StartButton.visible:
		show_message("Survive!")

		await get_tree().create_timer(1.0).timeout



func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	$MessageTimer.stop()
	start_game.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
