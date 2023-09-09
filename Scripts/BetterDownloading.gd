extends Node

var BrewInfo

var Client = HTTPClient.new()

var clientinfo = {"version": database.appver, "Client": OS.get_distribution_name()}
var uniheaders = "User-Agent: VerseDroid ver {version} {Client} client"
var responseheaders = {}
var iconname: String
var file 

var DLthread = Thread.new()
var mutex = Mutex.new()
var waitforreq = Semaphore.new()

var ConnectOk: bool
var ConnectWarn: bool = true

var wiiucdn = "wiiu.cdn.fortheusers.org" 
var switchcdn = "switch.cdn.fortheusers.org"
#This is a variable instead of being hard-coded so that in the future this could maybe support other repos

func InitialConnection():
	IP.clear_cache(wiiucdn)
	Client.connect_to_host(wiiucdn)
	Client.poll()
	while Client.get_status() != Client.STATUS_CONNECTED:
		Client.poll()
		if Client.get_status() == 0 or 2 or 4:
			print(Client.get_status())
			if ConnectWarn:
				OS.alert("Could not connect to the appstore server. No new images or homebrew will be loaded.", "No Network Connection")
			ConnectOk = false
			break
	if Client.get_status() == Client.STATUS_CONNECTED:
		ConnectOk = true
		print("Okay")
	

func Download(url, headers):
	Client.poll()
	if Client.get_status() == 8:
		IP.clear_cache(wiiucdn)
		InitialConnection()
		print("Doof")
	else:
		Client.poll()
		file = FileAccess.open(BrewInfo.InternalDownloadDir+url.get_file(),FileAccess.WRITE_READ)
		Client.request(HTTPClient.METHOD_GET, url, [uniheaders.format(clientinfo), headers])
		while Client.get_status() == 6:
			Client.poll()
			if Client.get_status() == 7:
				responseheaders = Client.get_response_headers_as_dictionary()
		while Client.get_status() == 7:
			Client.poll()
			var buffer = Client.read_response_body_chunk()
			file.store_buffer(buffer)
		FileCleanUp()

func FileCleanUp():
	if FileAccess.file_exists(BrewInfo.InternalDownloadDir+"repo.json"):
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+"repo.json", BrewInfo.RepoDir)
	if FileAccess.file_exists(BrewInfo.InternalDownloadDir+"icon.png"):
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+"icon.png", BrewInfo.InternalDownloadDir+iconname+".png")
		DirAccess.rename_absolute(BrewInfo.InternalDownloadDir+iconname+".png", BrewInfo.IconDir+iconname+".png")
	if FileAccess.file_exists(BrewInfo.InternalDownloadDir+iconname+".zip"):
		BrewInfo.setini.load(BrewInfo.inifilepath)
		if BrewInfo.setini.has_section_key("Directories", "HomeBrewDirectory"):
			var HBD = BrewInfo.setini.get_value("Directories", "HomeBrewDirectory")
			if DirAccess.dir_exists_absolute(HBD):
				pass
		else:
			print("Homebrew directory key not found")
	Satellite.emit_signal("DownloadComplete")


func DownloadRepo():
	ConnectWarn = true
	DLthread.start(Download.bind("/repo.json", "Accept: application/json"))
	#Download("/repo.json", "Accept: application/json")
	Satellite.emit_signal("DownloadStarted", false)

func DownloadIcon(appname):
	iconname = appname
	ConnectWarn = false
	Download("/packages/"+appname+"/icon.png","Accept: image/png")
	Satellite.emit_signal("DownloadStarted", false)

func DownloadBrew(appname):
	iconname = appname
	ConnectWarn = true
	Download("/zips/"+appname+".zip", "Accept: application/zip")
	Satellite.emit_signal("DownloadStarted", true)
