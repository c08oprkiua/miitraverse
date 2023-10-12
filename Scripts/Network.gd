extends Node

var Client = HTTPClient.new()
var thread = Thread.new()

#want to tie these variables together 
var formatas = {"id1": MountedEXT}: 
	get:
		if MountedEXT == formatas.get("id1"):
			return formatas
		else: 
			MountedEXT = formatas.get("id1")
			return formatas
var MountedEXT: 
	set(newEXT):
		MountedEXT = newEXT
		if formatas.get("id1") != newEXT:
			formatas["id1"] = MountedEXT

var currenthost: String
var currentpage
var networkarray = {}
var headers = []
var response: PackedByteArray
var retrycap = 50
var isfetch: bool
signal Done

var destination = "user://{foldername}/{filename}.xml"
var cachefile = FileAccess.open(destination, FileAccess.WRITE_READ)

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

func FetchManager(input):
	print(input)
	if ThreadBusyCheck():
		thread.start(PageRequest.bind(input))

func ConnectionManager(input):
	if not input is int:
		return
	if ThreadBusyCheck():
		thread.start(InitialConnect)
		thread.wait_to_finish()

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
	if DaBa.UseCache and isfetch:
		var cachefile = FileAccess.open(destination, FileAccess.WRITE_READ)
		var nameoffile 
		if DaBa.Tbl[currentpage].get("URL-EXT"):
			print("Variable filename")
			nameoffile = DaBa.Tbl[currentpage].get("Filename")
			nameoffile = nameoffile.format(formatas)
			print(nameoffile)
		else:
			print("Static filename")
			nameoffile = DaBa.Tbl[currentpage].get("Filename")
		var saveas = {"foldername": currenthost,"filename": nameoffile}
		destination = destination.format(saveas)
#		cachefile.store_buffer()
	print("Thread wrapped up")
	response.clear()

func InitialConnect():
	var CurrentURL = DaBa.settings.get_value("Networks", currenthost)
	Client.connect_to_host(CurrentURL)
	Client.poll()
	var retry = 0
	while not Client.get_status() == 5:
		Client.poll()
		if Client.get_status() == 2:
			break
		if Client.get_status() == 2 or 4:
			break
			var timer = Timer.new()
			if not timer.is_stopped():
				timer.start(10)
			if timer.is_stopped():
				print("Could not connect to "+currenthost)
				break
	if Client.get_status() == 5:
		print("Connected to "+currenthost+" !")
		isfetch = false
	emit_signal.call_deferred("Done")



#if it's a community post page, else something like "communities" or whatever
func PageRequest(page):
	currentpage = page
	print("Begin")
	Client.poll()
	#This variable is set so that this information doesn't change while the function
	#is using it; it is NOT redundant
	var extdata = MountedEXT
	var url
	var urlframe
	if Client.get_status() == 8:
		IP.clear_cache(currenthost)
		InitialConnect()
		print("Doof")
		return
	#This checks if the URL has any extra data that needs to be edited in,
	#like a community or post ID
	if DaBa.Tbl[page].get("URL-EXT"):
		print("Extra data detected")
		url = DaBa.Tbl[page].duplicate()
		urlframe = url.get("URL")
		url = urlframe.format(formatas)
	else:
		print("Static URL")
		url = DaBa.Tbl[page].get("URL")
	print(url)
	Client.request(HTTPClient.METHOD_GET, url, headers)
	Client.poll()
	while Client.get_status() != 7:
		Client.poll()
	while Client.get_status() == 7:
		response.append_array(Client.read_response_body_chunk())
	print("Got body")
	isfetch = true
	emit_signal.call_deferred("Done")
