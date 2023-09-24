extends VBoxContainer

var config = DaBa.settings
const setpath = "user://settings.ini"
var indexnum = 0

const globaldefaults = {
	"dropdown": {
		"Spoof": "Wii U",
		"Network": "NoNameVerse", #NoNameVerse
	},
	"binary": {
		"OfflineCache": false, #Save offline by default
		"Debug": false, #Make the Debug menu visible
	},
	"detailed": {
		"UITint": Color.CORNFLOWER_BLUE,
		"3DSCert": "", #The console cert necessary to fully mimic a 3DS
		"WiiUCert": "", #The console cert necessary to fully mimic a Wii U 
	},
}

const versedefaults = {
	"OfflineCache": false,
	"Spoof": 0, #Wii U
	"UITint": "",
	"UseUniqueTint": true,
}

func _ready():
	config.load(setpath)
	if not FileAccess.file_exists(setpath):
		Defaults()
		config.set_value("Networks", "NoNameVerse", "olvapi.nonamegiven.xyz")
		config.save(setpath)
	config.load(setpath)
	DaBa.GlobalColorTint = config.get_value("Globals", "UITint")
	$"NinePatchRect".self_modulate =DaBa.GlobalColorTint
	NetworkIndexLoad()
	Network.currenthost = config.get_value("Globals", "Network")

func Defaults():
	for sections in globaldefaults.keys():
		for keys in globaldefaults[sections].keys():
			config.set_value("Globals", keys, globaldefaults[sections].get(keys))

func NetworkIndexLoad():
	for networks in DaBa.settings.get_section_keys("Networks"):
		Network.networkarray[indexnum] = networks
		indexnum += 1
		if not DirAccess.dir_exists_absolute("user://"+networks):
			DirAccess.make_dir_absolute("user://"+networks)
			for entries in versedefaults.keys():
				config.set_value(networks, entries, config.get_value("Globals", entries))
	Satellite.emit_signal("RefreshNetworks")
