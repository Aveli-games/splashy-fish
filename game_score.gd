extends HBoxContainer


func set_color(color):
	get_node("Rank").add_theme_color_override("font_color", color)
	get_node("Name").add_theme_color_override("font_color", color)
	get_node("Score").add_theme_color_override("font_color", color)
