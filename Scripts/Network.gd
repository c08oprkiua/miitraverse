extends Node

var Config = ConfigFile.new()
var Client = HTTPClient.new()
var xml = XMLParser.new()
var clientinfo = {"version": database.appver, "Client": OS.get_distribution_name()}
var uniheaders = "User-Agent: VerseDroid ver {version} {Client} client"
var headers = []
var currenthost: String
var response: PackedByteArray
var retrycap = 50


var pretendourl: String = "discovery.olv.pretendo.cc" #Pretendo's URL.. but you need a token for it, so RIP
var nonameurl: String = "olvapi.nonamegiven.xyz" #the main URL
var rverseurl: String = "n3ds.rverse.club" #This might be it, it might not be

#These *should* be universal between Miiverse revivals, due to the neccessity of the structuring for compatibility with Miiverse compatible games/apps
var communitypage = "/v1/commmunities/{community_id}" 
	#community_id should be the community_id from the the allcommunities response
	#or, in other words. database.communities[x].get("community_id")
var posts = "/posts" #append to communitypage
var allcommunities = "/v1/communities/" #shows all communities
var asjson = "?json=1" #NoNameVerse specific: add to the end of any subURL to get the response as a JSON
var icon = "/img/icons/{community_id}.jpg" #the icons
var userpage = "users/show?pid=[{user_id}]"
var userme = "/users/me"
var newcontent = "/communities/{titleid}/new"
var homepage = "/titles/show"
var people = "v1/people"

var this
var titleid

func InitialConnect():
	Config.load("user://settings.ini")
	#Basically, NoNameVerse is a fallback default. Additional networks are saved in the INI so that users can add/remove their own networks through settings
	#These URLs will be made at startup if they don't exist, in another script
	var savedurl = Config.get_value("Settings", "Network", "NoNameVerse")
	currenthost = Config.get_value("Networks", savedurl, "olvapi.nonamegiven.xyz")
	Client.connect_to_host(currenthost)
	Client.poll()
	var retry = 0
	while not Client.get_status() == 5:
		Client.poll()
		#if Client.get_status() == 2 or 4:
			#if retry > retrycap:
			#	print("Connection had too many disconnects and failed")
			#	break
			#retry += 1
	if Client.get_status() == 5:
		print("Connected to "+currenthost+" !")

func PageRequest(url):
	if Client.get_status() == 8:
		IP.clear_cache(currenthost)
		InitialConnect()
		print("Doof")
		return
	Client.request(HTTPClient.METHOD_GET, url, headers)
	Client.poll()
	print(Client.get_status())
	while Client.get_status() != 7:
		Client.poll()
	while Client.get_status() == 7:
		response.append_array(Client.read_response_body_chunk())
	if Config.get_value("Settings", "OfflineCache", true):
		FileAccess.open("user://"+Config.get_value("Settings", "Network")+"/communities.xml", FileAccess.WRITE_READ).store_buffer(response)
	var strres = response.get_string_from_utf8()
	database.communities = strres
	print("Got body")
