extends Node

@export var obstacle_scene: PackedScene
var score

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
	$Player.start($StartPosition.position)
	$HUD.update_score("Score: %s" % score)
	$HUD.show_timed_message("Get Ready", $StartTimer.wait_time)
	$StartTimer.start()
	$Music.play()

func _on_obstacle_timer_timeout():
	# Create a new instance of the Mob scene.
	var obstacle = obstacle_scene.instantiate()

	# Choose a random location on Path2D.
	var obstacle_spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation")
	obstacle_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
	obstacle.position = obstacle_spawn_location.position

	# Choose the velocity for the mob.
	obstacle.linear_velocity = 400 * Vector2.LEFT

	# Spawn the mob by adding it to the Main scene.
	add_child(obstacle)

func _on_start_timer_timeout():
	$ObstacleTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score("Score: %s" % score)
