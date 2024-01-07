extends VBoxContainer

@export var global: bool

func _ready():
	if global:
		$Title.text = 'Global'

func _on_visibility_changed():
	if visible:
		if global:
			# TODO: make scoreboard reactive. Can be behind since http is async
			GlobalHighScores.fetch_scores()
			$HighScores.populate_scoreboard(GlobalHighScores.scores)
		else:
			$HighScores.populate_scoreboard(LocalHighScores.scores)
