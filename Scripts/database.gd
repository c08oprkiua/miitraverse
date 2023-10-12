extends Node

#This script is where the various parsing scripts for the XML files are stored, 
#which turn the unfriendly XML format into a much nicer JSON-esque dictionary
#array for easier usability for assets within the app

#I access settings from so many different places, it'll be a global variable,
#I don't care anymore
const setpath = "user://settings.ini"
var settings = ConfigFile.new()

#Global settings, so functions don't have to keep fetching the file
var UseCache
var MountedBubble

#When the XML is parsed, these variables are where the handy dandy dictionaries are stored
	#list of communities and their properties
var communities
	#The currently loaded post page
var posts
var recieved = {
	"Communities": null,
	"Posts": null,
}


#This is the best I could do for organizing a *lot* of related data used throughout
#the app without straight up relying on a JSON file. Enjoy.
var Tbl = {
	"Home": {
		"data": null,
		"Node": "UIMargin/MainUI/HomeList",
		"Filename": "home",
		"XML-ID": "",
		"Bubble": "",
		"URL": "v1/topics", #WWP Home page
		"URL-EXT": false,
	},
	"Communities": {
		"data": null,
		"Node": "UIMargin/MainUI/Communities",
		"XML-ID": "community",
		"Filename": "communities",
		"Bubble": "res://Scenes/Bubbles/CommunityBubble.tscn",
		#"Bubble": "res://Scenes/community.tscn", 
		"URL": "/v1/communities/",
		"URL-EXT": false,
	},
	"Settings": {
		"Node": "UIMargin/MainUI/Settings"
		
	},
	"Posts": {
		"data": null,
		"Node": "UIMargin/MainUI/Posts",
		"XML-ID": "post",
		"Filename": "comm{id1}posts", 
		"Bubble": "res://Scenes/Bubbles/PostBubble.tscn",
		"URL": "/v1/communities/{id1}/posts",
		"URL-EXT": true,
	},
	"DMs": {
		"data": null,
		"Node": "UIMargin/MainUI/DMs",
		"Filename": "", #Fuck you Snapchat
		"Bubble": "",
		"URL": "",
	},
	"Notifications": {
		"data": null,
		"Node": "UIMargin/MainUI/Notifications",
		"Filename": "",
		"Bubble": "",
		"URL": "",
		"URL-EXT": false,
	},
	"People": {
		"data": null,
		"Node": "UIMargin/MainUI/Notifications",
		"Filename": "people",
		"Bubble": "",
		"URL": "/v1/people",
		"URL-EXT": false,
	},
}


#This will probably be moved to elsewhere
func PaintingToTGA(raw):
	#compressed (gzip?) base64 tga
	var paintingbuffer = Marshalls.base64_to_raw(raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var paintingbuffer2 = paintingbuffer.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(paintingbuffer2)
	return painting

func ParamPacker():
	var packinfo = ParamPack.new()
	var device# = settings.get_value(Network.currenthost, "Spoof", settings.get_value("Globals", "Spoof"))
