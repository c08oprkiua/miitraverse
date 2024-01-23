extends Node

#Dev notes: Mid transition to new, simplified function system,

var API:HTTPClient = HTTPClient.new()
var thread:Thread = Thread.new()

var OlvAPI:OliveClient = OliveClient.new()

#All endpoints!!!!
#https://github.com/PretendoNetwork/miiverse-api/blob/main/src/services/api/index.ts

var CurrentAPIHost: StringName
var CurrentURL:String

var isfetch: bool
signal thread_is_free

#Unverified endpoints
var asjson:String = "?json=1"
var icon:String = "/img/icons/{community_id}.jpg" #the icons
var userpage:String = "users/show?pid=[{user_id}]"
var mypage:String = "users/me"
var newcontent:String = "/communities/{community_id}/new"

func _ready():
	Satellite.connect("SwapNetworks", ConnectionManager)
	Satellite.connect("NetFetch", FetchManager)

func FetchManager(page:StringName, args:Array= []):
	print("page fetch requested; calling ", page, " with args", args)
	if ThreadBusyCheck():
		thread.start(OlvAPI.callv(page, args))

func ConnectionManager(input: int):
	var ProfRes: ProfileRes = DaBa.ProfileCheck(input)
	var APIURL: StringName = ProfRes.url
	OlvAPI.service_token = ProfRes.ServiceToken
	#Cause if its a match, why reconnect to the same URL?
	if CurrentAPIHost != APIURL:
		CurrentAPIHost = APIURL
		OlvAPI.domain = CurrentAPIHost
		print("Swap API; profile ", input, ", going to ", CurrentAPIHost)
		if ThreadBusyCheck():
			thread.start(OlvAPI.connect_to_api)
		else:
			if !is_connected("thread_is_free",ConnectionManager):
				connect("thread_is_free", ConnectionManager.bind(input), CONNECT_ONE_SHOT)

func ThreadBusyCheck() -> bool:
	if thread.is_alive():
		print("API: thread is still working")
		return false
	elif thread.is_started():
		print("Thread has been started")
		return false
	else: 
		emit_signal("thread_is_free")
		print("API: Proceeding to thread")
		return true

func WrapUpThread()-> Variant:
	if ThreadBusyCheck():
		print("Thread wrapped up")
		return thread.wait_to_finish()
	else:
		print("Thread is still alive")
		return null
