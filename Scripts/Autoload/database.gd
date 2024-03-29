extends Node

const savepath: String = "user://settings.tres"

var global_settings: GlobalSettingRes
var current_profile:ProfileRes

#global variable versions of the settings, so that they can be accessed without having
# a Global Settings class open
var OfflineCache: bool
var UseCache: bool
var MountedBubble
var ThreeDS_Certificate: String
var Wii_U_Certificate: String
var OverrideTints: bool
var Tint: Color

#This is a reference to all existing profiles, using their int value to find their folder, and then 
#from there, finding whatever data is needed through their settings.tres file
var ProfileArray: Array[int] = []
#This must be a value in the above array

var CurrentProfile: int

func _ready():
	Satellite.connect("SwapNetworks", SwitchProfiles)
	Satellite.connect("RefreshNetworks", SwitchProfiles)
	global_settings = SettingsCheck()
	current_profile = ProfileCheck(global_settings.DefaultNetwork)
	ActiveNow()

func ProfileArrayFiller():
	for directories in DirAccess.get_directories_at("user://"):
		if directories.contains("Profile"):
			var profnum: int = directories.lstrip("Profile").to_int()
			print(profnum)
			ProfileArray.append(profnum)
	#Satellite.emit_signal("RefreshNetworks")

#Helper functions that check for somethings existence, and return a new instance if one isn't found

#Global settings
func SettingsCheck() -> GlobalSettingRes:
	if ResourceLoader.exists(savepath):
		return ResourceLoader.load(savepath) as GlobalSettingRes
	else:
		var glob: GlobalSettingRes = GlobalSettingRes.new()
		glob.Defaults()
		return glob

#A given profile (number)'s settings
func ProfileCheck(number: int) -> ProfileRes:
	var prof: ProfileRes
	var profpath: String = "user://Profile"+String.num(number)+"/settings.tres"
	if ResourceLoader.exists(profpath):
		prof = ResourceLoader.load(profpath) as ProfileRes
	else:
		prof = ProfileRes.new()
		prof.Defaults()
	return prof

#The cache of a particular file, also sorts out the cache/buffer priority heirarchy
func ContentCheck(number: int, file: String) -> PackedByteArray:
	var filepath: String = "user://Profile"+String.num(number)+"/"+file
	if UseCache:
		print("Cache enabled")
		if FileAccess.file_exists(filepath):
			print("File exists")
			return FileAccess.get_file_as_bytes(filepath)
		else:
			print("File could not be retrieved")
			if not API.response.is_empty():
				print("API response given")
				return API.response
			else:
				print("API response is also empty")
				return PackedByteArray([])
	if not UseCache:
		print("Cache disabled")
		if not API.response.is_empty():
			print("API response given")
			return API.response
		else:
			print("API response is empty")
			return PackedByteArray([])
	else:
		print("Well that's concerning")
		return PackedByteArray([])

#Padding function to call SetFuncVars in instances where an int is not provided
func ActiveNow():
	if ProfileArray.has(global_settings.DefaultNetwork):
		SwitchProfiles(global_settings.DefaultNetwork)
	else:
		SwitchProfiles(0)

func SwitchProfiles(now:int):
	#Check if cache should be enabled
	current_profile = ProfileCheck(now)
	if global_settings.OfflineCache or current_profile.OfflineCache:
		UseCache = true
	else:
		UseCache = false
	#Check which UI color should be used. I want to clean this up.
	ChangeUIColors()

func ChangeUIColors():
	var mountedcolor:Color
	if OverrideTints:
		mountedcolor = Tint
	elif current_profile.UseUniqueTint:
		mountedcolor = current_profile.BubbleTint
	else:
		mountedcolor = Tint
	#Switch Bubbles
	var bubbletex:StyleBox = load("res://TRESfiles/Bubbles/bubble.stylebox") as StyleBox
	bubbletex.bg_color = mountedcolor
	ContentBubble.UniversalBubble = bubbletex
	Satellite.emit_signal("NewBubble")
	#Todo: Now do the painting color overrides


#Legacy code

	#list of communities and their properties
#var communities
	#The currently loaded post page
#var posts
#var recieved = {
#	"Communities": null,
#	"Posts": null,
#}


#Legacy lookup table. It's still here until I can figure out that nothing I haven't
#messed with in a minute uses it
#var Tbl = {
#	"Home": {
#		"data": null,
#		"Node": "UIMargin/MainUI/HomeList",
#		"Filename": "home",
#		"XML-ID": "",
#		"Bubble": "",
#		"URL": "v1/topics", #WWP Home page
#		"URL-EXT": false,
#	},
#	"Communities": {
#		"data": null,
#		"Node": "UIMargin/MainUI/Communities",
#		"XML-ID": "community",
#		"Filename": "communities",
#		"Bubble": "res://Scenes/Bubbles/CommunityBubble.tscn",
#		#"Bubble": "res://Scenes/community.tscn", 
#		"URL": "/v1/communities/",
#		"URL-EXT": false,
#	},
#	"Settings": {
#		"Node": "UIMargin/MainUI/Settings"
#	},
#	"Posts": {
#		"data": null,
#		"Node": "UIMargin/MainUI/Posts",
#		"XML-ID": "post",
#		"Filename": "comm{id1}posts", 
#		"Bubble": "res://Scenes/Bubbles/PostBubble.tscn",
#		"URL": "/v1/communities/{id1}/posts",
#		"URL-EXT": true,
#	},
#	"DMs": {
#		"data": null,
#		"Node": "UIMargin/MainUI/DMs",
#		"Filename": "", #Fuck you Snapchat
#		"Bubble": "",
#		"URL": "",
#	},
#	"Notifications": {
#		"data": null,
#		"Node": "UIMargin/MainUI/Notifications",
#		"Filename": "",
#		"Bubble": "",
#		"URL": "",
#		"URL-EXT": false,
#	},
#	"People": {
#		"data": null,
#		"Node": "UIMargin/MainUI/Notifications",
#		"Filename": "people",
#		"Bubble": "",
#		"URL": "/v1/people",
#		"URL-EXT": false,
#	},
#}


