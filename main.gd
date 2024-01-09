extends Node

@export var obstacle_scene: PackedScene

const HIGH_JUMP_VALUE = .9
const WATER_GATE_VALUE = .25

var score
var obstacle_gap_size
var rng = RandomNumberGenerator.new()
var high_jump = false
var water_gate_streak = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.start($StartPosition.position)
	LocalHighScores.load()
	change_music($MainMenuMusic)

func game_over():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ScoreTimer.stop()
	$ObstacleTimer.stop()
	change_music($GameOverSound)
	$HUD.show_high_score(score)

func new_game():
	high_jump = false
	water_gate_streak = 0
	rng.seed = hash("FlappyFish")
	score = 0
	obstacle_gap_size = 300
	$HUD.update_score("Score: %s" % score)
	$HUD.show_timed_message("Get Ready", $StartTimer.wait_time)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$StartTimer.start()
	change_music($Music)

func change_music(music_node):
	$Music.stop()
	$GameOverSound.stop()
	$MainMenuMusic.stop()
	music_node.play()

func _on_obstacle_timer_timeout():
	# Create a new instance of the obstacle scene.
	var obstacle = obstacle_scene.instantiate()

	# Choose a random location on Path2D.
	var obstacle_spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation")
	var height = rng.randf()

	## Reroll if previous was a high jump
	while high_jump:
		height = rng.randf()
		if height > HIGH_JUMP_VALUE:
			high_jump = false

	while water_gate_streak > 2:
		height = rng.randf()
		if height < WATER_GATE_VALUE:
			water_gate_streak = 0

	# Check height to add to or reset water gate streak or indicate high jump encountered
	if height < WATER_GATE_VALUE:
		water_gate_streak = 0
		if height <= HIGH_JUMP_VALUE:
			high_jump = true
	else:
		water_gate_streak += 1

	obstacle_spawn_location.progress_ratio = height

	# Set the obstacle's position to a random location.
	obstacle.position = obstacle_spawn_location.position

	# Choose the velocity for the obstacle.
	obstacle.linear_velocity = 400 * Vector2.LEFT

	# Parameterized gap in obstacle (px tall)
	obstacle.set_gap(obstacle_gap_size)
	obstacle_gap_size = max(obstacle_gap_size-10, 100)

	# Spawn the obstacle by adding it to the Main scene.
	add_child(obstacle)

func _on_start_timer_timeout():
	if not $Player.visible:
		$Player.start($StartPosition.position)
	$ObstacleTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score("Score: %s" % score)

func _on_hud_main_menu_shown():
	change_music($MainMenuMusic)
