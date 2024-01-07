extends Node

var scores = []
var error = false
var http = HTTPRequest.new()
var server_url = "https://warm-abacus-410306.uw.r.appspot.com/"
#var server_url = "http://localhost:3000"

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	fetch_scores()

func fetch_scores():
	http.request(server_url)

func post_score(initials: String, score: int):
	var body = JSON.stringify({"name": initials, "score": score})
	var headers = ["Content-Type: application/json"]
	var request_error = http.request(server_url, headers, HTTPClient.METHOD_POST, body)
	if request_error != OK:
		push_error("An error occurred in the HTTP request.")
		error = true
	pass

func _on_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print('error getting global scores')
		pass
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json && json.has("data") && typeof(json["data"]) == TYPE_ARRAY:
		scores = json["data"]

