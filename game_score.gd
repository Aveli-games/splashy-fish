extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_color(color):
	get_node("Rank").add_theme_color_override("font_color", color)
	get_node("Name").add_theme_color_override("font_color", color)
	get_node("Score").add_theme_color_override("font_color", color)
