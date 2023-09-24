extends Node

var Client = HTTPClient.new()
var thread = Thread.new()

var headers = []

var currenthost: String
var networkarray = {}

var response: PackedByteArray
var retrycap = 50

#Unverified endpoints
var asjson = "?json=1" #NoNameVerse specific: add to the end of any subURL to get the response as a JSON
var icon = "/img/icons/{community_id}.jpg" #the icons
var userpage = "users/show?pid=[{user_id}]"
var mypage = "users/me"
var newcontent = "/communities/{community_id}/new"
var homepage = "/titles/show"

func _ready():
	Satellite.connect("SwapNetworks", ThreadManager)
	Satellite.connect("NetFetch", ThreadManager)

#I hate the existence of this, it makes things more complicated than they need to be,
# but it is a neccessary evil because thread are wacky and can't just be started in signals
func ThreadManager(input):
	print(input)
	#All the page requests are, conveniently, all strings
	if input is String:
		print("Page Request")
		if ThreadBusyCheck():
			thread.start(PageRequest.bind(input))
			thread.wait_to_finish()
			print("Done")
	#And all the base network connection requests are all integers for the index
	elif input is int:
		print("Initial Connection")
		if ThreadBusyCheck():
			thread.start(InitialConnect)
			thread.wait_to_finish()
			print("Done")

func ThreadBusyCheck():
	if thread.is_alive():
		print("thread is busy")
		return false
	else: 
		print("Proceeding to thread")
		return true

func InitialConnect():
	#Next two lines will be changed so that they don't load a setting and instead
	#use currenthost
	var CurrentURL = DaBa.settings.get_value("Networks", currenthost)
	Client.connect_to_host(CurrentURL)
	Client.poll()
	var retry = 0
	while not Client.get_status() == 5:
		Client.poll()
		if Client.get_status() == 2:
			break
		#if Client.get_status() == 2 or 4:
			#if retry > retrycap:
			#	print("Connection had too many disconnects and failed")
			#	break
			#retry += 1
	if Client.get_status() == 5:
		print("Connected to "+currenthost+" !")

#URL will be one of the subURLs, filename should probably be the community_id 
#if it's a community post page, else something like "communities" or whatever
func PageRequest(page):
	Client.poll()
	if Client.get_status() == 8:
		IP.clear_cache(currenthost)
		InitialConnect()
		print("Doof")
		return
	var url = DaBa.Tbl[page].get("URL")
	print(url)
	Client.request(HTTPClient.METHOD_GET, url, headers)
	Client.poll()
	while Client.get_status() != 7:
		Client.poll()
	while Client.get_status() == 7:
		response.append_array(Client.read_response_body_chunk())
	if DaBa.settings.get_value("Globals", "OfflineCache") or DaBa.settings.get_value(currenthost, "OfflineCache"):
		var saveas = {"foldername": currenthost,"filename": DaBa.Tbl[page].get("Filename")}
		FileAccess.open(("user://{foldername}/{filename}.xml".format(saveas)), FileAccess.WRITE_READ).store_buffer(response)
	print("Got body")
	DaBa.CommunityListXML(response, page)
