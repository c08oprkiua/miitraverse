extends Node

var AccSer = HTTPClient.new()
var CurrentAccSer: StringName

var response: PackedByteArray

var headers: Array = []

var thread = Thread.new()

func WiiUConnect(input):
	if not input is int:
		return
	var ProfRes: Profile = DaBa.ProfileCheck(input)
	var APIURL: StringName = ProfRes.AccountServWiiU
	if not CurrentAccSer == APIURL:
		CurrentAccSer = APIURL
		if ThreadBusyCheck():
			thread.start(AccServWiiU())
	#Cause if its a match, why reconnect to the same URL?

func ThreadBusyCheck():
	if thread.is_alive():
		print("thread is busy")
		return false
	else: 
		print("Proceeding to thread")
		return true

func AccServWiiU():
	AccSer.connect_to_host(CurrentAccSer)
	AccSer.poll()
	var retry: bool
	var timedout = get_tree().create_timer(10.0).timeout
	connect(timedout.timeout, func(): retry = false)
	while not AccSer.get_status() == 5:
		AccSer.poll()
		if not retry:
			break
	#Importantly, returns the 0Auth2 token
	AccSer.request(HTTPClient.METHOD_POST, "/v1/api/oauth20/access_token/generate", headers)
	
	
	#This request uses the 0Auth2 token
	AccSer.request(HTTPClient.METHOD_GET, "/v1/api/provider/service_token/@me", headers)

func WiiUGet0Auth2():
	pass

func WiiUGetMiiverseToken():
	pass

func WiiUGetPID():
	pass



func AccServ3DS():
	pass
