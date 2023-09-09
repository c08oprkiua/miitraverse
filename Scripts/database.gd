extends Node

var appver: String = "0.0.1"

var xml = XMLParser.new()

#When the XML is parsed, these variables are where the handy dandy dictionaries are stored
	#list of communities and their properties
var communities

var compage
var posts

#These variables are used by XMLfileprocess and shouldn't be accessed outside of this script
#...I mean, there's nothing *stopping* you from doing it, but it wouldn't have much of a point
var itname
var information
var commtoggle


#Posts url for NSMBU US
var samplepost = "http://olvapi.nonamegiven.xyz/v1/communities/1407375153044736/posts"

var parampack
var servicetoken

var headers = {
	"x-nintendo-parampack": parampack
	#x-nintendo-servicetoken
	#X-Nintendo-Whitelist
	
}

var settingstemplate = {
	"Network": "nonameverse",
	"OfflineCache": true
	
}

func XMLfileprocess(file):
	xml.open(file)
	var stringtionary: Dictionary
	var entry = 0
	while xml.read() != ERR_FILE_EOF:
		var checkdata = xml.get_node_type()
		match checkdata:
			1:
				var nodename = xml.get_node_name()
				if nodename == "communities":
					pass
				if nodename == "community":
					#entry = entry + 1
					stringtionary[entry] = {}
					commtoggle = true
				else: 
					itname = nodename
			2:
				if commtoggle:
					stringtionary[entry][itname] = information
				if xml.get_node_name() == "community":
					entry = entry + 1 
					commtoggle = false
			3:
				information = xml.get_node_data()
			4:
				pass
			5:
				pass
			6:
				pass
	communities = stringtionary
	var savecache = FileAccess.open("user://communities.json", FileAccess.WRITE_READ)
	savecache.store_string(JSON.stringify(communities))
	Satellite.emit_signal("SafeRepo")

const platforms = {
	
	
}

const regions = {
	
	
	
	
}

const languages = {
	"ja": 0,
	"en": 1,
	"fr": 2,
	"de": 3,
	"it": 4,
	"es": 5,
	"zh": 6,
	"ko": 7,
	"nl": 8,
	"pt": 9,
	"ru": 10,
}

const countries = {}

const areas = {}


	#Example param pack, when decoded from Base64 (it sends encoded to Base64)
#\title_id\1407375153045504\access_key\4045990404\platform_id\1\region_id\2
#\language_id\1\country_id\49\area_id\6\network_restriction\0\friend_restriction\0
#\rating_restriction\17\rating_organization\1\transferable_id\5221273826140205058
#\tz_name\America/Phoenix\utc_offset-25200\ 

#This may be A really messy way of doing this, but it is easy to read, and works, so idc
func parampackmaker():
	var title_id #1407375153045504
	var access_key = 0 #Found in meta.xml of a Wii U app or hardcoded in a 3DS app, but either way not needed
	var platform_id #1, either 1 or 2 depending on if it's a Wii U or 3DS
	var region_id #2
	var language_id = languages.get(OS.get_locale_language(), 1)
	var country_id #49
	var area_id #6
	var network_restriction #0
	var friend_restriction #0
	var rating_restriction #17
	var rating_organization #1
	var transferable_id #5221273826140205058
	var tz_name #America/Phoenix
	var utc_offset #-25200
	
	var paramtemplate = ["title_id", title_id, 
	"access_key", access_key, 
	"platform_id", platform_id, 
	"region_id", region_id,
	"language_id", language_id,
	"country_id", country_id,
	"area_id", area_id,
	"network_restriction", network_restriction,
	"friend_restriction", friend_restriction,
	"rating_restriction", rating_restriction,
	"rating_organization", rating_organization,
	"transferable_id", transferable_id,
	"tz_name", tz_name,
	"utc_offset", utc_offset
	]
	var rawparam = ("\\"+"\\".join(paramtemplate)+"\\")
	print(rawparam)
	parampack = Marshalls.utf8_to_base64(rawparam)
	print(headers)
