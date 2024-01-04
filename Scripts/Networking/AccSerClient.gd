extends HTTPClient

var account_domain:String
var headers:PackedStringArray
var response:PackedByteArray



#This is a special "mega" function that runs through everything until it reaches
#The Miiverse service token, which it then returns
func AccServWiiU():
	return
	print("Starting account server connection chain; connecting to domain...")
	connect_to_host(account_domain)
	poll()
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
	poll()
	while not get_status() == HTTPClient.STATUS_CONNECTED:
		poll()
	return true

func WiiUGet0Auth2() -> PackedByteArray:
	print("Getting 0Auth2")
	var response: PackedByteArray
	var postcontent: String
	request(HTTPClient.METHOD_POST, "/v1/api/oauth20/access_token/generate", headers, postcontent)
	#headers include:
	# "Host", which is domain
	#"X-Nintendo-Client-ID"
	#"X-Nintendo-Client-Secret"
	return response

func WiiUGetMiiverseToken():
	print("Getting Miiverse token")
	request(HTTPClient.METHOD_GET, "/v1/api/provider/service_token/@me", headers)

func WiiUGetPID():
	pass

func AccServ3DS():
	pass
