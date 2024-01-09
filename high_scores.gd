extends VBoxContainer

@export var game_score_scene: PackedScene

func populate_scoreboard(scores):
	clean_scoreboard()
	var rank = 1
	for entry in scores:
		var new_score = game_score_scene.instantiate()
		new_score.get_node("Rank").text = "#%s" % str(rank)
		new_score.get_node("Name").text = entry["name"]
		new_score.get_node("Score").text = str(entry["score"])
		add_child(new_score)
		rank += 1

func clean_scoreboard():
	for child in get_children():
		child.free() # Need to free child immediately so we don't double up scores briefly
