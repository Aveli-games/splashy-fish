extends Node

func _ready():
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	http.request("https://warm-abacus-410306.uw.r.appspot.com/")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["data"])
