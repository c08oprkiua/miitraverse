extends VBoxContainer

var ThisProfile

const versedefaults = {
	"OfflineCache": false,
	"Spoof": 0, #Wii U
	"UITint": "",
	"UseUniqueTint": true,
}

const nodeindex = {
	"dropdown": {
		"Spoof": "SpoofClients/ClientSpoof",
		"Network": "DefaultNetwork/DefaultNetwork",
	},
	"binary": {
		"OfflineCache": "Cache",
	},
	"detailed": {
		"UITint": "DefaultTint/Picker",
		"3DSCert": "", #The console cert necessary to fully mimic a 3DS
		"WiiUCert": "", #The console cert necessary to fully mimic a Wii U 
	}
}

const globaldefaults = {
	"dropdown": {
		#"Spoof": 0, #Wii U
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


func _ready():
	Satellite.connect("ProfileLoad", ButtonsSet)

#This is the magic function that sets all the button states in settings
func ButtonsSet():
	for entries in DaBa.settings.get_section_keys(ThisProfile):
		match entries:
			"binary":
				for keys in nodeindex[entries].keys():
					var anode = get_node(nodeindex[entries].get(keys))
					anode.set_pressed(DaBa.settings.get_value("Globals", keys))
			"detailed":
				pass
			"dropdown":
				pass

func Defaults():
	for sections in globaldefaults.keys():
		for keys in globaldefaults[sections].keys():
			DaBa.settings.set_value(ThisProfile, keys, globaldefaults[sections].get(keys))

func Globalset(name, value):
	DaBa.settings.set_value(ThisProfile, name, value)
	DaBa.settings.save(DaBa.setpath)

func _on_cache_toggled(button_pressed):
	Globalset("OfflineCache", button_pressed)

func _on_set_reset_pressed():
	Defaults()

func _on_debug_mode_toggled(button_pressed):
	Globalset("Debug", button_pressed)

func _on_client_spoof_item_selected(index):
	Globalset("Spoof", index)

func _on_default_network_item_selected(index):
	Globalset("Network", index)

func _on_picker_color_changed(color):
	Globalset("UITint", color)
