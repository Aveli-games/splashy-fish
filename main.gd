extends Node

@export var obstacle_scene: PackedScene
var score
var obstacle_gap_size

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("obstacles", "queue_free")
	$Player.start($StartPosition.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$ObstacleTimer.stop()
	$HUD.show_game_over($GameOverSound.stream.get_length())
	$Music.stop()
	$GameOverSound.play()

func new_game():
	score = 0
	obstacle_gap_size = 300
	if not $Player.visible:
		$Player.start($StartPosition.position)
	$HUD.update_score("Score: %s" % score)
	$HUD.show_timed_message("Get Ready", $StartTimer.wait_time)
	$StartTimer.start()
	$GameOverSound.stop()
	$Music.play()

func _on_obstacle_timer_timeout():
	# Create a new instance of the obstacle scene.
	var obstacle = obstacle_scene.instantiate()

	# Choose a random location on Path2D.
	var obstacle_spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation")
	obstacle_spawn_location.progress_ratio = randf()

	# Set the obstacle's position to a random location.
	obstacle.position = obstacle_spawn_location.position

	# Choose the velocity for the obstacle.
	obstacle.linear_velocity = 250 * Vector2.LEFT

	# Parameterized gap in obstacle (px tall)
	obstacle.set_gap(obstacle_gap_size)
	obstacle_gap_size = max(obstacle_gap_size-10, 100)

	# Spawn the obstacle by adding it to the Main scene.
	add_child(obstacle)

func _on_start_timer_timeout():
	$ObstacleTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score("Score: %s" % score)
