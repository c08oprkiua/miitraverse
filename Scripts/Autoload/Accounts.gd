extends Node

var AccSer:HTTPClient = HTTPClient.new()
var CurrentAccSer: StringName

var response: PackedByteArray

var headers: Array = []

var thread:Thread = Thread.new()

func WiiUConnect(input):
	if not input is int:
		return
	var ProfRes: ProfileRes = DaBa.ProfileCheck(input)
	var APIURL: StringName = ProfRes.AccountServWiiU
	if not CurrentAccSer == APIURL:
		CurrentAccSer = APIURL
		if ThreadBusyCheck():
			#thread.start(AccServWiiU())
			AccServWiiU()
	#Cause if its a match, why reconnect to the same URL?

func ThreadBusyCheck():
	if thread.is_alive():
		print("Acc: thread is busy")
		return false
	else: 
		print("Acc: Proceeding to thread")
		return true

func AccServWiiU():
	return
	print("Starting account server connection chain; connecting to domain...")
	AccSer.connect_to_host(CurrentAccSer)
	AccSer.poll()
	if not ServerConnectLoop(10.0):
		print("Timed out at connecting phase")
		return
	print("Acc: Connected to domain successfully")
	#Importantly, returns the 0Auth2 token
	WiiUGet0Auth2()
	if response.is_empty():
		print("Acc: Response error; response empty")
	#This request uses the 0Auth2 token
	WiiUGetMiiverseToken()

func ServerConnectLoop(timer_seconds: float) -> bool:
	print("retry loop for ",timer_seconds," seconds")
	var retry: bool = true
	var quicktimer:Timer = Timer.new()
	var timedout:Signal = quicktimer.timeout
	timedout.connect(func(): retry = false)
	quicktimer.one_shot = true
	quicktimer.autostart = true
	quicktimer.wait_time = timer_seconds
	quicktimer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	self.add_child(quicktimer)
	print(quicktimer.paused)
	print(quicktimer.wait_time)
	AccSer.poll()
	while not AccSer.get_status() == HTTPClient.STATUS_CONNECTED:
		if quicktimer.is_stopped():
			quicktimer.call_deferred("start")
		AccSer.poll()
		if not retry:
			print("Acc: Connect attempt has timed out")
			break
		print(quicktimer.time_left)
	if not retry:
		return false
	else:
		return true

func ServerRequestLoop(timer_seconds: float) -> PackedByteArray:
	var retry: bool = true
	var timedout:Signal = get_tree().create_timer(timer_seconds).timeout
	timedout.connect(func(): retry = false)
	while AccSer.get_status() == HTTPClient.STATUS_CONNECTING:
		AccSer.poll()
		if not retry:
			print("Acc: server request has timed out")
			return response
	var response:PackedByteArray
	while AccSer.get_status() == HTTPClient.STATUS_BODY:
		response.append_array(AccSer.read_response_body_chunk())
		AccSer.poll()
	return response

func WiiUGet0Auth2() -> PackedByteArray:
	print("Getting 0Auth2")
	var response: PackedByteArray
	var postcontent: String
	AccSer.request(HTTPClient.METHOD_POST, "/v1/api/oauth20/access_token/generate", headers)
	#headers include:
	# "Host", which is domain
	#"X-Nintendo-Client-ID"
	#"X-Nintendo-Client-Secret"
	return response

func WiiUGetMiiverseToken():
	print("Getting Miiverse token")
	AccSer.request(HTTPClient.METHOD_GET, "/v1/api/provider/service_token/@me", headers)


func WiiUGetPID():
	pass

func AccServ3DS():
	pass
