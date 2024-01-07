extends VBoxContainer

@export var game_score_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populate_scoreboard():
	clean_scoreboard()
	var rank = 1
	for entry in LocalHighScores.scores:
		var new_score = game_score_scene.instantiate()
		new_score.get_node("Rank").text = "#%s" % str(rank)
		new_score.get_node("Name").text = entry["name"]
		new_score.get_node("Score"). text = str(entry["score"])
		add_child(new_score)
		rank += 1

func clean_scoreboard():
	for child in get_children():
		child.queue_free()
