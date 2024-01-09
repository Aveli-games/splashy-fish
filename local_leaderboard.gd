extends VBoxContainer

signal local_scores_populated
signal global_scores_populated

@export var global: bool

const HIGH_SCORE_COLOR = 0xf06d45ff  # Kind of a goldish yellow

func _ready():
	reset_title_text()
	if global:
		GlobalHighScores.leaderboard_fetched.connect(_on_leaderboard_fetched)
	else:
		LocalHighScores.local_high_score.connect(_on_local_high_score)

func _on_visibility_changed():
	if visible:
		reset_title_text()
		if global:
			$HighScores.populate_scoreboard(GlobalHighScores.scores)
			global_scores_populated.emit()
		else:
			$HighScores.populate_scoreboard(LocalHighScores.scores)
			local_scores_populated.emit()

func _on_leaderboard_fetched():
	if visible && global:
		$HighScores.populate_scoreboard(GlobalHighScores.scores)

# Highlight local high score
func _on_local_high_score(rank):
	if visible && not global:
			await local_scores_populated
			for score_entry in $HighScores.get_children():
				var cur_rank = "#" + str(rank + 1)
				if score_entry.get_node("Rank").text == cur_rank:
					score_entry.set_color(Color.hex(HIGH_SCORE_COLOR))
					set_title_text("Personal High Score!", Color.hex(HIGH_SCORE_COLOR))
					break

# Highlight global high score
func highlight_global_score(initials, score):
	if visible && global:
		var score_nodes = $HighScores.get_children()
		var board_size = score_nodes.size()
		var rank = board_size
		
		for score_entry in score_nodes:
			if score_entry.get_node("Name").text == initials && int(score_entry.get_node("Score").text) == int(score):
				rank = int(score_entry.get_node("Rank").text.erase(0, 1)) - 1
		
		if rank < board_size:
			score_nodes[rank].set_color(Color.hex(HIGH_SCORE_COLOR))
			set_title_text("Global High Score!", Color.hex(HIGH_SCORE_COLOR))

func set_title_text(title: String, color: Color):
	$Title.text = title
	$Title.add_theme_color_override("font_color", color)

func reset_title_text():
	if global:
		$Title.text = "Global"
	else:
		$Title.text = "Personal"
	
	$Title.remove_theme_color_override("font_color")
