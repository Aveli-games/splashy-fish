extends VBoxContainer

func _on_visibility_changed():
	if visible:
		$HighScores.populate_scoreboard()
