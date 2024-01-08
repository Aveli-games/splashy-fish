extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal main_menu_shown

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

func _on_scoreboard_button_pressed():
	$MainMenu.hide()
	$Leaderboards.show()

func _on_name_submit_button_pressed():
	var initials = $HighScoreEntry/NameEntry.text
	var score = $HighScoreEntry/PlayerScore.text
	LocalHighScores.submit_score(initials, score)
	GlobalHighScores.post_score(initials, int(score))
	$HighScoreEntry.hide()
	$Leaderboards.show()

func _on_main_menu_button_pressed():
	for child in get_children():
		child.hide()
	$MainMenu.show()

func _on_main_menu_visibility_changed():
	if $MainMenu.visible:
		main_menu_shown.emit()
