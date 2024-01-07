extends Node

const SCORE_SAVE_PATH = "user://local_high_scores.json"
const ENCRYPTION_PASS = "keytochangeforrelease"

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
		var json = JSON.new()
		var data = json.parse_string(file.get_as_text())
		file.close()

		if typeof(data) == TYPE_ARRAY:
			# for backward compat, only needed for cam & tris once.
			# Replace if/else with just scores=data afterward
			if data.size() > 0 && data[0].has("Name"):
				scores = _convert_score_file(data)
				save()
			else:
				scores = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func is_high_score(score):
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
				rank = scores.find(entry)
				break
			if int(score) == entry_score:
				rank = scores.find(entry) + 1
	return rank

func submit_score(name, score):
	var rank = get_score_rank(score)

	# Check if it's a high score (rank less than max count)
	if rank < HIGH_SCORE_COUNT_LIMIT:
		scores.insert(rank, {"name": name, "score": score})
		save()
		return true

# for backward compat, only needed for cam & tris once
func _convert_score_file(data):
	for entry in data:
		if entry["Name"]:
			entry["name"] = entry["Name"]
			entry.erase("Name")
		if entry["Score"]:
			entry["score"] = entry["Score"]
			entry.erase("Score")
	return data



