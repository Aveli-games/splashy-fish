extends VBoxContainer

@export var global: bool

func _ready():
	if global:
		$Title.text = 'Global'

func _on_visibility_changed():
	if visible:
		if global:
			# TODO: populate with global scores
			pass
		else:
			$HighScores.populate_scoreboard(LocalHighScores.scores)
