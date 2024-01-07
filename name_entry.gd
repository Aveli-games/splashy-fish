extends LineEdit


func _on_text_changed(new_text):
	var caret_pos = caret_column
	text = new_text.to_upper()
	caret_column = caret_pos
