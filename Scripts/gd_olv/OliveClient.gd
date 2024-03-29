extends HTTPClient
class_name OliveClient

var domain:String

var parse:MiiverseParser
var pack:ParamPackRes = ParamPackRes.new()
var service_token:String

const pack_temp:String = "x-nintendo-parampack: {parampack}"
const service_token_temp:String = "x-nintendo-servicetoken: {token}"

class queries:
	var json:bool = false
	

#This is static so it can be used even for non OliveClient purposes
static func assemble_headers(parpak:ParamPackRes, servicetoken:String) -> PackedStringArray:
	var new_headers:PackedStringArray = []
	new_headers.append(pack_temp.format({"parampack": parpak.assemble()}))
	new_headers.append(service_token_temp.format({"token": servicetoken}))
	return new_headers

func internal_connect(url:String, chainload:Callable = func(): return):
	print("Good Morning Miiverse! Today we're connecting to ", url, " and then calling ", chainload)
	blocking_mode_enabled = true
	connect_to_host(url)
	poll()
	var accumulate:int = 0
	print("Our current connection status is... ", get_status())
	while get_status() == HTTPClient.STATUS_RESOLVING || HTTPClient.STATUS_CONNECTING:
		accumulate = accumulate + 1
		poll()
		if get_status() == HTTPClient.STATUS_CONNECTED:
			break
		print("Connecting... ", accumulate)
		OS.delay_msec(100)
		if accumulate > 100:
			print("Accumulate limit of 100 is reached")
			break
	if get_status() == HTTPClient.STATUS_CONNECTED:
		print("Connected!")
		#This chainload is my solution to an apparent race condition I was running into with 
		#calling internal_connect in another function, where it would not complete before the
		#rest of the calling function ran, no matter what I tried with mutexes, awaits, etc.
		chainload.call()
		return
	elif get_status() == HTTPClient.STATUS_CANT_CONNECT | HTTPClient.STATUS_CANT_RESOLVE:
		print("Couldn't connect or resolve")
	return

func internal_request(mode:HTTPClient.Method,endpoint: String, send_data:String= "") -> PackedByteArray:
	poll()
	#Occasionally, the connection will time out, which causes a connection error
	if get_status() == HTTPClient.STATUS_CONNECTION_ERROR:
		IP.clear_cache(domain)
		print("Connection error, reconnecting...")
		internal_connect(domain)
	var response:PackedByteArray = []
	match mode:
		METHOD_GET:
				request(HTTPClient.METHOD_GET, endpoint, OliveClient.assemble_headers(pack, service_token))
		METHOD_POST:
			request(HTTPClient.METHOD_POST, endpoint, OliveClient.assemble_headers(pack, service_token), send_data)
	poll()
	while get_status() == HTTPClient.STATUS_REQUESTING:
		poll()
	while get_status() == HTTPClient.STATUS_BODY:
		response.append_array(read_response_body_chunk())
		print("Recieving response...")
	print("Got body")
	return response



#Bug: first call does nothing, second goes through then freezes at BROKEN BIT
func connect_to_domain(url: String = domain):
	print("Connecting to Domain")
	internal_connect(url, get_base_endpoint)

func connect_to_api(url: String = domain):
	print("Connecting to API")
	internal_connect(url)

func get_base_endpoint():
	var response: PackedByteArray = internal_request(METHOD_GET,"/v1/endpoint")
	var accum:int = 0
	FileAccess.open("res://discdump.txt",FileAccess.WRITE_READ).store_buffer(response)
	var responsexml:XMLParser = XMLParser.new()
	responsexml.open_buffer(response)
	while responsexml.read() != ERR_FILE_EOF:
		accum = accum + 1
		var element: XMLParser.NodeType = responsexml.get_node_type()
		print(element)
		if element == XMLParser.NODE_ELEMENT:
			var name: String = responsexml.get_node_name()
			print(name)
			if name == "api_host":
				responsexml.read()
				var apihost: String = responsexml.get_node_data()
				print(apihost)

func get_communities() -> Array[CommRes]:
	var raw:PackedByteArray = internal_request(METHOD_GET,"/v1/communities")
	var communities:Array[CommRes] = []
	return communities

func get_community(community_id:String) -> CommRes:
	parse = MiiverseParser.new(internal_request(METHOD_GET,"v1/communities/"+community_id+"/posts"))
	var community: CommRes = parse.parse_for_community()
	return community

func get_community_from_titleid(title_id:String):
	pack.title_id = title_id
	parse = MiiverseParser.new(internal_request(METHOD_GET,"v1/communities/0/posts"))

func get_post_from_community(post_id:String):
	pass

func get_post_from_community_tid(titleid:String, postid:String):
	pass

func get_friend_messages():
	parse = MiiverseParser.new(internal_request(METHOD_GET,"/v1/friend_messages"))

func get_topics():
	parse = MiiverseParser.new(internal_request(METHOD_GET,"/v1/topics"))

func post_to_community(community_id: String, post:PostRes):
	pass
