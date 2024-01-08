extends VBoxContainer

signal local_scores_populated

@export var global: bool

const HIGH_SCORE_COLOR = 0xf06d45ff  # Kind of a goldish yellow

func _ready():
	if global:
		$Title.text = 'Global'
		GlobalHighScores.leaderboard_fetched.connect(_on_leaderboard_fetched)
	LocalHighScores.high_score.connect(_on_high_score)

func _on_visibility_changed():
	if visible:
		if global:
			$HighScores.populate_scoreboard(GlobalHighScores.scores)
		else:
			$HighScores.populate_scoreboard(LocalHighScores.scores)
			local_scores_populated.emit()

func _on_leaderboard_fetched():
	$HighScores.populate_scoreboard(GlobalHighScores.scores)

func _on_high_score(rank):
	if visible:
		await local_scores_populated
		for score_entry in $HighScores.get_children():
			var compare_rank = score_entry.get_node("Rank").text
			var cur_rank = "#" + str(rank + 1)
			if score_entry.get_node("Rank").text == cur_rank:
				score_entry.set_color(Color.hex(HIGH_SCORE_COLOR))
