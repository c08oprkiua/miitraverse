extends VBoxContainer

#This script does the following:
#	Manages creation and update signals of the network array (Network.networkarray)
#	Puts the fallback network into the Networks section of "Networks"
#	Sets the global variables in DaBa used by other scripts

var config = DaBa.settings
const setpath = "user://settings.ini"
var indexnum = 0
var Profile = load("res://Scenes/Bubbles/ProfileSettingsBubble.tscn")
var fallbacknet = ProjectSettings.get_setting("MiiTraverse/Globals/Fallback_Network")
var fallbackurl = ProjectSettings.get_setting("MiiTraverse/Globals/Fallback_URL")
var mountedcolor

const globals = [
	"DebugMode",
	"Fallback_Network",
	"Fallback_URL",
	"OfflineCache",
	"Mimicked_Device",
	"3DS_Certificate",
	"Wii_U_Certificate",
	"Tint",
]

const profile = [
	"Name",
	"URL",
	"OfflineCache",
	"Mimicked_Device",
	"UI_Tint",
	"UseUniqueTint",
]

func _ready():
	DaBa.settings.load(setpath)
	if not DaBa.settings.has_section("Networks"):
		DaBa.settings.set_value("Networks", fallbacknet, fallbackurl)
		DaBa.settings.save(setpath)
	DaBa.settings.load(setpath)
	Network.currenthost = DaBa.settings.get_value("Globals", "Network")
	NetworkIndexLoad()
	Satellite.connect("NewProfile", LoadProfileBubble)
	Satellite.connect("NewProfile", InitNewProfile)
	Satellite.connect("SwapNetworks", SetFuncVars)
	SetFuncVars()
	Satellite.connect("SwitchTabs", VisibilityToggle)
	print("Settings init complete")

func VisibilityToggle(tabnow, active):
	if tabnow == "Settings":
		if active:
			print("Hello from Settings")
			show()
		else:
			hide()
			print("Goodbye from Settings")
	else:
		hide()
		print("Not from Settings")

func Defaults():
	for values in globals:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Globals/"+values)
		DaBa.settings.set_value("Globals", values, settingvalue)
	DaBa.settings.set_value("Globals", "Network", 
	ProjectSettings.get_setting("MiiTraverse/Globals/Fallback_Network"))

func InitNewProfile(name):
	DirAccess.make_dir_absolute("user://"+name)
	for entries in profile:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Verse/"+entries)
		DaBa.settings.set_value(name, entries, settingvalue)

func NetworkIndexLoad():
	for networks in DaBa.settings.get_section_keys("Networks"):
		Network.networkarray[indexnum] = networks
		if not DirAccess.dir_exists_absolute("user://"+networks):
			InitNewProfile(networks)
		add_child(Profile.instantiate())
		Satellite.emit_signal("LoadProfile", indexnum)
		indexnum += 1
	Satellite.emit_signal("RefreshNetworks")

func LoadProfileBubble():
	indexnum+1
	Network.networkarray[indexnum] = indexnum
	add_child(Profile.instantiate())
	Satellite.emit_signal("LoadProfile", indexnum)

func SetFuncVars():
	if DaBa.settings.get_value(
		"Globals", "OfflineCache") or DaBa.settings.get_value(
			Network.currenthost, "OfflineCache"):
		DaBa.UseCache = true
	else:
		DaBa.UseCache = false
	mountedcolor = DaBa.settings.get_value("Globals", "Tint")
	if DaBa.settings.get_value(Network.currenthost, "UseUniqueTint"):
		mountedcolor = DaBa.settings.get_value(Network.currenthost, "Tint")
	BlowBubbles()

func BlowBubbles():
	var bubbletex = load("res://TRESfiles/Bubbles/bubble.tres")
	bubbletex.bg_color = DaBa.GlobalColorTint