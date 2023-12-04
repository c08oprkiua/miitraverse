extends Node

#Dev notes: Mid transition to new, simplified function system,

var API = HTTPClient.new()
var thread = Thread.new()

#All endpoints!!!!
#https://github.com/PretendoNetwork/miiverse-api/blob/main/src/services/api/index.ts

#want to tie these variables together 
#This might be scrappable (yay)
#var formatas = {"id1": MountedEXT}: 
#	get:
#		if MountedEXT == formatas.get("id1"):
#			return formatas
#		else: 
#			MountedEXT = formatas.get("id1")
#			return formatas
#var MountedEXT: 
#	set(newEXT):
#		MountedEXT = newEXT
#		if formatas.get("id1") != newEXT:
#			formatas["id1"] = MountedEXT


var CurrentAPIHost: StringName
var CurrentURL:String

var headers = []
var response: PackedByteArray

var isfetch: bool
signal Done

#Unverified endpoints
var asjson = "?json=1" #NoNameVerse specific: add to the end of any subURL to get the response as a JSON
var icon = "/img/icons/{community_id}.jpg" #the icons
var userpage = "users/show?pid=[{user_id}]"
var mypage = "users/me"
var newcontent = "/communities/{community_id}/new"
var homepage = "/titles/show"

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
		print("thread is busy")
		return false
	else: 
		print("Proceeding to thread")
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
	timedout.connect(func(): retry = false)
	while not API.get_status() == 5:
		API.poll()
		if not retry:
			return false

func APIPageRequest(page, filename):
	#ConnectionTest()
	if API.get_status() == 8:
		IP.clear_cache(CurrentAPIHost)
		InitialAPIConnect()
		print("Doof")
	API.request(HTTPClient.METHOD_GET, page, headers)
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
