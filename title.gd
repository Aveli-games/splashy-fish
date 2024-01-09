extends Label

const HIGH_SCORE_COLOR = 0xf06d45ff  # Kind of a goldish yellow

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	LocalHighScores.local_high_score.connect(_on_local_high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_local_high_score(rank):
	text = "Local High Score!"
	add_theme_color_override("font_color", Color.hex(HIGH_SCORE_COLOR))

func reset():
	text = "High Scores"
	remove_theme_color_override("font_color")
