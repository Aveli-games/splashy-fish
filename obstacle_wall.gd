extends RigidBody2D

func set_gap(gap_size):
	$TopGate.translate(Vector2(0, -gap_size/2))
	$BottomGate.translate(Vector2(0, gap_size/2))

func _on_visible_on_screen_notifier_2d_screen_exited():
	if position.x < -$VisibleOnScreenNotifier2D.get_rect().size.x/2:
		queue_free()
