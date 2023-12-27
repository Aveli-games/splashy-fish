extends Node

@export var obstacle_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("obstacles", "queue_free")
	$ObstacleTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
