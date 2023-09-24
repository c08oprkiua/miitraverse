extends Node

#This script is where the various parsing scripts for the XML files are stored, 
#which turn the unfriendly XML format into a much nicer JSON-esque dictionary
#array for easier usability for assets within the app

#I access settings from so many different places, it'll be a global variable,
#I don't care anymore
const setpath = "user://settings.ini"
var settings = ConfigFile.new()
var GlobalColorTint =  Color(Color.DARK_CYAN)
var xml = XMLParser.new()

#When the XML is parsed, these variables are where the handy dandy dictionaries are stored
	#list of communities and their properties
var communities
	#The currently loaded post page
var posts

#These variables are used by XMLfileprocess and shouldn't be accessed outside of this script
#...I mean, there's nothing *stopping* you from doing it, but it wouldn't have much of a point
var itname
var information
var commtoggle

const FileNameChart = {
	"Communities": "communities",
	"Posts": "post",
}

#This is the best I could do for organizing a *lot* of related data used throughout
#the app without straight up relying on a JSON file. Enjoy.
var Tbl = {
	"Home": {
		"data": "",
		"Node": "UIMargin/MainUI/ActivityFeedList",
		"Filename": "activityfeed",
		"XML-ID": "",
		"Bubble": "",
		"URL": "",
	},
	"Communities": {
		"data": "",
		"Node": "UIMargin/MainUI/CommunityList",
		"XML-ID": "community",
		"Filename": "communities",
		"Bubble": "res://Scenes/community.tscn",
		"URL": "/v1/communities/"
	},
	"Settings": {
		"Node": "UIMargin/MainUI/Settings"
		
	},
	"Posts": {
		"data": "",
		"Node": "UIMargin/MainUI/PostList",
		"XML-ID": "post",
		"Filename": "comm{community_id}posts", 
		"Bubble": "res://Scenes/PostShell.tscn",
		"URL": "/v1/commmunities/{community_id}/posts",
	},
	"DMs": {
		"data": "",
		"Node": "UIMargin/MainUI/DMs",
		"Filename": "", #Fuck you Snapchat
		"Bubble": "",
		"URL": "",
	},
	"Notifications": {
		"data": "",
		"Node": "UIMargin/MainUI/Notifications",
		"Filename": "",
		"Bubble": "",
		"URL": "",
	},
	"People": {
		"data": "",
		"Node": "UIMargin/MainUI/Notifications",
		"Filename": "people",
		"Bubble": "",
		"URL": "/v1/people",
	},
}

var isnull: bool
#This just parses communities, but it could be modified to parse posts
func CommunityListXML(raw, datatype):
	print("Beginning XML processing")
	var TriggerNode = Tbl[datatype].get("XML-ID")
	#Add something right here to check if offlinecache is enabled before trying to load the file,
	#If it's disabled, check the RAM packedbytearray for data, and load it if there's something there
	#Maybe also add a check for a variable that is only set to true when a download has successfully
	#completed
	xml.open_buffer(raw)
	if settings.get_value("Globals", "OfflineCache"):
		#then it'll load a file from a file instead
		pass
	var stringtionary: Dictionary
	var entry = 0
	while xml.read() != ERR_FILE_EOF:
		var checkdata = xml.get_node_type()
		match checkdata:
			1:
				var nodename = xml.get_node_name()
				#This node name tells the function that it's gotten to the 
				#relevant data, and starts a dictionary for it
				if nodename == TriggerNode:
					stringtionary[entry] = {}
					commtoggle = true
				#This enters a key into the aforemtioned dictionary
				else: 
					itname = nodename
					if xml.is_empty():
						print("is null")
			2:
				if commtoggle:
					#I feel like something was gonna go here but idr what
					stringtionary[entry][itname] = information
				if xml.get_node_name() == TriggerNode:
					entry = entry + 1 
					commtoggle = false
			3:
				if xml.is_empty():
					information = null
				else:
					information = xml.get_node_data()
			4:
				pass
			5:
				pass
			6:
				pass
	Tbl[datatype]["data"] = stringtionary
	if settings.get_value("Globals", "OfflineCache") or settings.get_value(Network.currenthost, "OfflineCache"):
		var savecache = FileAccess.open("user://"+Network.currenthost+"/"+Tbl[datatype].get("Filename")+".json", FileAccess.WRITE_READ)
		savecache.store_string(JSON.stringify(stringtionary))
	Satellite.emit_signal.call_deferred("LoadInfo", datatype)
	print("XML processed")


#This will probably be moved to elsewhere
func PaintingToTGA(raw):
	#compressed (gzip?) base64 tga
	var paintingbuffer = Marshalls.base64_to_raw(raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var paintingbuffer2 = paintingbuffer.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(paintingbuffer2)
	return painting
