extends Node

#Dev notes: Mid transition to new, simplified function system,

var API = HTTPClient.new()
var thread = Thread.new()

var OlvAPI:OliveClient = OliveClient.new()

#All endpoints!!!!
#https://github.com/PretendoNetwork/miiverse-api/blob/main/src/services/api/index.ts

var CurrentAPIHost: StringName
var CurrentURL:String

const endpoint:String = "/v1/endpoint"

var headers:Array = []
var response: PackedByteArray

var isfetch: bool
signal Done

#Unverified endpoints
var asjson:String = "?json=1" #NoNameVerse specific: add to the end of any subURL to get the response as a JSON
var icon:String = "/img/icons/{community_id}.jpg" #the icons
var userpage:String = "users/show?pid=[{user_id}]"
var mypage:String = "users/me"
var newcontent:String = "/communities/{community_id}/new"

func _ready():
	Satellite.connect("SwapNetworks", ConnectionManager)
	Satellite.connect("NetFetch", FetchManager)
	connect("Done", WrapUpThread)

func FetchManager(page, filename):
	print(page, filename)
	if ThreadBusyCheck():
		thread.start(APIPageRequest.bind(page, filename))

func ConnectionManager(input):
	if not input is int:
		return
	var ProfRes: ProfileRes = DaBa.ProfileCheck(input)
	var APIURL: StringName = ProfRes.url
	if not CurrentAPIHost == APIURL:
		CurrentAPIHost = APIURL
		print("Swap API; ", input)
		print(CurrentAPIHost)
		if ThreadBusyCheck():
			thread.start(InitialAPIConnect)
	#Cause if its a match, why reconnect to the same URL?

func ThreadBusyCheck():
	if thread.is_alive():
		print("API: thread is busy")
		return false
	else: 
		print("API: Proceeding to thread")
		return true

func WrapUpThread():
	if thread.is_alive():
		thread.wait_to_finish()
	print("Thread wrapped up")

func InitialAPIConnect():
	API.connect_to_host(CurrentURL)
	ConnectionTest()
	if API.get_status() == 5:
		print("Connected to "+CurrentAPIHost+" !")
		isfetch = false
	else:
		print("Could not connect to ",CurrentAPIHost,", with error ",API.get_response_code())
	emit_signal.call_deferred("Done")

func ConnectionTest():
	API.poll()
	var retry: bool = true
	var timedout = get_tree().create_timer(10.0).timeout
	var count:int = 100000000
	timedout.connect(func(): retry = false)
	while not API.get_status() == 5:
		count = count + 1
		API.poll()
		if not retry:
			return false
		if count == 10:
			return false
	return true

func APIPageRequest(page, filename):
	#ConnectionTest()
	if API.get_status() == 8:
		IP.clear_cache(CurrentAPIHost)
		InitialAPIConnect()
		print("Doof")
	API.request(HTTPClient.METHOD_GET, page+endpoint, headers)
	API.poll()
	while API.get_status() != 7:
		API.poll()
	while API.get_status() == 7:
		response.append_array(API.read_response_body_chunk())
	print("Got body")
	if DaBa.UseCache and filename != null:
		var caching = FileAccess.open("user://Profile"+String.num(DaBa.CurrentProfile)+"/"+filename, FileAccess.WRITE_READ)
		caching.store_buffer(response)
	isfetch = true
	emit_signal.call_deferred("Done")


#XHRpdGxlX2lkXDE0MDczNzUxNjg3ODM3MTRcYWNjZXNzX2tleVwwXHBsYXRmb3JtX2lkXDFccmVn aW9uX2lkXDJcbGFuZ3VhZ2VfaWRcMVxjb3VudHJ5X2lkXDQ5XGFyZWFfaWRcMTFcbmV0d29ya19y ZXN0cmljdGlvblwwXGZyaWVuZF9yZXN0cmljdGlvblwwXHJhdGluZ19yZXN0cmljdGlvblwxN1xy YXRpbmdfb3JnYW5pemF0aW9uXDFcdHJhbnNmZXJhYmxlX2lkXDEwMTYxMzgxNTYxMTY1MTc1NDI5 XHR6X25hbWVcQW1lcmljYS9OZXdfWW9ya1x1dGNfb2Zmc2V0XC0xODAwMFw=
