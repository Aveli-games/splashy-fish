extends Node

var scores = []
var http = HTTPRequest.new()

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	fetch_scores()

func fetch_scores():
	http.request("https://warm-abacus-410306.uw.r.appspot.com/")

func post_score():
	pass

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json.has("data") && typeof(json["data"]) == TYPE_ARRAY:
		scores = json["data"]

