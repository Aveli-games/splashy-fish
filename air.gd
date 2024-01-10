extends Area2D


func _on_area_entered(area):
	if area.name == "Player":
		$ExitWater.play()


func _on_area_exited(area):
	if area.name == "Player":
		$EnterWater.play()
