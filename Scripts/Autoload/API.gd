extends Node

#Dev notes: Mid transition to new, simplified function system,

var API:HTTPClient = HTTPClient.new()
var thread:Thread = Thread.new()

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
		pass

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
			OlvAPI.domain = CurrentAPIHost
			if thread.is_started():
				print("API: thread is started")
				return
			thread.start(OlvAPI.connect_to_api)
	#Cause if its a match, why reconnect to the same URL?

func ThreadBusyCheck() -> bool:
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


#XHRpdGxlX2lkXDE0MDczNzUxNjg3ODM3MTRcYWNjZXNzX2tleVwwXHBsYXRmb3JtX2lkXDFccmVn aW9uX2lkXDJcbGFuZ3VhZ2VfaWRcMVxjb3VudHJ5X2lkXDQ5XGFyZWFfaWRcMTFcbmV0d29ya19y ZXN0cmljdGlvblwwXGZyaWVuZF9yZXN0cmljdGlvblwwXHJhdGluZ19yZXN0cmljdGlvblwxN1xy YXRpbmdfb3JnYW5pemF0aW9uXDFcdHJhbnNmZXJhYmxlX2lkXDEwMTYxMzgxNTYxMTY1MTc1NDI5 XHR6X25hbWVcQW1lcmljYS9OZXdfWW9ya1x1dGNfb2Zmc2V0XC0xODAwMFw=
