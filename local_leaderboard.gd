extends VBoxContainer

@export var global: bool

func _ready():
	if global:
		$Title.text = 'Global'
		GlobalHighScores.leaderboard_fetched.connect(_on_leaderboard_fetched)

func _on_visibility_changed():
	if visible:
		if global:
			$HighScores.populate_scoreboard(GlobalHighScores.scores)
		else:
			$HighScores.populate_scoreboard(LocalHighScores.scores)

func _on_leaderboard_fetched():
	$HighScores.populate_scoreboard(GlobalHighScores.scores)

