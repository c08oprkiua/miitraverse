extends HTTPClient
class_name PageReq

var headers
var response
var CurrentHost

func InitialConnect(host):
	CurrentHost = DaBa.settings.get_value(host, "Url")
	connect_to_host(CurrentHost)
	poll()
	var retry = 0
	while not get_status() == 5:
		poll()
		if get_status() == 2:
			break
		#if Client.get_status() == 2 or 4:
			#if retry > retrycap:
			#	print("Connection had too many disconnects and failed")
			#	break
			#retry += 1
	if get_status() == 5:
		print("Connected to "+host+" !")

func GetPage(page, cachedir):
	if get_status() == 8:
		IP.clear_cache(CurrentHost)
		print("Doof")
		return
	request(HTTPClient.METHOD_GET, page, headers)
	poll()
	while get_status() != 7:
		poll()
	while get_status() == 7:
		response.append_array(read_response_body_chunk())
	print("Got body")
