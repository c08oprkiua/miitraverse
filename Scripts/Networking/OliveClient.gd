extends HTTPClient
class_name OliveClient

var domain:String

var pack:ParamPackRes = ParamPackRes.new()
var service_token:String

const pack_temp:String = "x-nintendo-parampack: {parampack}"
const service_token_temp:String = "x-nintendo-servicetoken: {token}"

#This is static so it can be used even for non OliveClient purposes
static func assemble_headers(parpak:ParamPackRes, service_token:String) -> PackedStringArray:
	var new_headers:PackedStringArray
	new_headers.append(pack_temp.format({"parampack": parpak.assemble()}))
	new_headers.append(service_token_temp.format({"token": service_token}))
	return new_headers

func internal_connect(url:String, chainload:Callable = func(): return):
	blocking_mode_enabled = true
	connect_to_host(url)
	poll()
	var accumulate:int = 0
	while get_status() == HTTPClient.STATUS_CONNECTING | HTTPClient.STATUS_RESOLVING:
		accumulate = accumulate + 1
		poll()
		print("Connecting... ", accumulate)
		OS.delay_msec(100)
	if get_status() == HTTPClient.STATUS_CONNECTED:
		print("Connected!")
		#This chainload is my solution to an apparent race condition I was running into with 
		#calling internal_connect in another function, where it would not complete before the
		#rest of the calling function ran, no matter what I tried with mutexes, awaits, etc.
		chainload.call()
	elif get_status() == HTTPClient.STATUS_CANT_CONNECT | HTTPClient.STATUS_CANT_RESOLVE:
		print("Couldn't connect or resolve")

func internal_get(endpoint:String) -> PackedByteArray:
	#Occasionally, the server will time out, which causes a connection error
	if get_status() == HTTPClient.STATUS_CONNECTION_ERROR:
		IP.clear_cache(domain)
		print("Connection error, reconnecting...")
		internal_connect(domain)
	request(HTTPClient.METHOD_GET, endpoint, OliveClient.assemble_headers(pack, service_token))
	var response:PackedByteArray
	poll()
	while get_status() == HTTPClient.STATUS_REQUESTING:
		poll()
	while get_status() == HTTPClient.STATUS_BODY:
		response.append_array(read_response_body_chunk())
		print("Recieving response...")
	return response

#Bug: first call does nothing, second goes through then freezes at BROKEN BIT
func connect_to_domain(url: String = domain):
	internal_connect(url, get_base_endpoint)

func connect_to_api(url: String = domain):
	internal_connect(url)

func get_base_endpoint():
	var response: PackedByteArray = internal_get("/v1/endpoint")
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

func get_communities():
	var response: PackedByteArray = internal_get("/v1/communities")
	print("Got body")
	if true:
		var caching = FileAccess.open("user://newcommfetch.xml", FileAccess.WRITE_READ)
		caching.store_buffer(response)

func get_community(community_id:String):
	request(HTTPClient.METHOD_GET, "v1/communities/"+community_id+"/posts", OliveClient.assemble_headers(pack, service_token))

func get_community_from_titleid(title_id:String):
	pack.title_id = title_id
	request(HTTPClient.METHOD_GET, "v1/communities/0/posts", OliveClient.assemble_headers(pack, service_token))

#This will be edited to take in a PostRes
func get_post_from_community(post_id:String):
	pass

func get_post_from_community_tid(titleid:String):
	pass

func get_friend_messages():
	var response:PackedByteArray = internal_get("/v1/friend_messages")

func get_topics():
	var response:PackedByteArray = internal_get("/v1/topics")
