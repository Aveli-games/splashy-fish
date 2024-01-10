extends Node

signal local_high_score

const SCORE_SAVE_PATH = "user://local_high_scores.json"
const ENCRYPTION_PASS = "riK4qcrq8N"

var version = 1

const HIGH_SCORE_COUNT_LIMIT = 10

var scores = []

func save():
	if scores.size() > HIGH_SCORE_COUNT_LIMIT:
		scores.resize(HIGH_SCORE_COUNT_LIMIT)

	var file = FileAccess.open_encrypted_with_pass(SCORE_SAVE_PATH, FileAccess.WRITE, ENCRYPTION_PASS)
	file.store_string(JSON.stringify(scores))
	file.close()

func load():
	var file = FileAccess.open_encrypted_with_pass(SCORE_SAVE_PATH, FileAccess.READ, ENCRYPTION_PASS)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()

		if typeof(data) == TYPE_ARRAY:
			scores = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func is_local_high_score(score):
	return HIGH_SCORE_COUNT_LIMIT > get_score_rank(score)

func get_score_rank(score):
	var rank = HIGH_SCORE_COUNT_LIMIT
	if scores.size() == 0:
		rank = 0
	else:
		rank = scores.size()
		for entry in scores:
			var entry_score = int(entry["score"])
			if int(score) > entry_score:
				rank = scores.rfind(entry)
				break
			if int(score) == entry_score:
				rank = scores.rfind(entry) + 1
	return rank

func submit_score(initials, score):
	var rank = get_score_rank(score)

	# Check if it's a high score (rank less than max count)
	if rank < HIGH_SCORE_COUNT_LIMIT:
		scores.insert(rank, {"name": initials, "score": score})
		save()
		local_high_score.emit(rank)
		return true
