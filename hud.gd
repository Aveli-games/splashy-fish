extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$GameScreen/Message.text = text
	$GameScreen/Message.show()

func show_timed_message(text, time):
	$GameScreen/Message.text = text
	$GameScreen/Message.show()
	$GameScreen/MessageTimer.wait_time = time
	$GameScreen/MessageTimer.start()

func show_game_over(time, score):
	if LocalHighScores.is_high_score(score):
		$GameScreen.hide()
		$HighScoreEntry.show()
	else:
		show_timed_message("Game Over", time)

		$GameScreen/RestartButton.show()

		# Wait until the MessageTimer has counted down.
		await $GameScreen/MessageTimer.timeout

		if $GameScreen/RestartButton.visible:
			$GameScreen/RestartButton.hide()
			$GameScreen.hide()
			$MainMenu.show()

func show_high_score(score):
	$GameScreen.hide()
	$HighScoreEntry/PlayerScore.text = str(score)
	$HighScoreEntry.show()

func update_score(score):
	$GameScreen/ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$GameScreen/Message.hide()

func _on_start_button_pressed():
	$MainMenu.hide()
	$GameScreen.show()
	$GameScreen/RestartButton.hide()
	$GameScreen/Message.hide()
	$GameScreen/MessageTimer.stop()
	start_game.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_scoreboard_button_pressed():
	$MainMenu.hide()
	$LocalLeaderboard.show()


func _on_name_submit_button_pressed():
	LocalHighScores.submit_score($HighScoreEntry/NameEntry.text, $HighScoreEntry/PlayerScore.text)
	$HighScoreEntry.hide()
	$LocalLeaderboard.show()


func _on_main_menu_button_pressed():
	for child in get_children():
		child.hide()
	$MainMenu.show()
