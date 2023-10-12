extends VBoxContainer

var config = DaBa.settings

#Partly just here so I am 200% sure I don't typo, lol
const setpath = "user://settings.ini"
var indexnum = 0
var tempcolor

#Key should match the desired setting in settings.ini,
#Value has to match a UNIQUE node name in the settings tree
const nodeindex = {
	"Mimicked_Device": "SpoofClients/ClientSpoof",
	"Network": "DefaultNetwork/DefaultNetwork",
	"OfflineCache": "Cache",
	"DebugMode": "DebugMode",
	"Tint": "DefaultTint/Picker",
	"3DS_Certificate": "", #The console cert necessary to fully mimic a 3DS
	"Wii_U_Certificate": "", #The console cert necessary to fully mimic a Wii U 
	"OverrideTints": "OverrideColors",
}

const globals = [
	"DebugMode",
	"Fallback_Network",
	"Fallback_URL",
	"OfflineCache",
	"Mimicked_Device",
	"3DS_Certificate",
	"Wii_U_Certificate",
	"Tint",
	"OverrideTints",
]

func _ready():
	if not FileAccess.file_exists(setpath):
		Defaults()
	ButtonsSet()

#This is the magic function that sets all the button states in settings
func ButtonsSet():
	for entries in config.get_section_keys("Globals"):
		var node = nodeindex.get(entries)
		match entries:
			"DebugMode", "OfflineCache", "OverrideTints":
				get_node(node).set_pressed(config.get_value("Globals", entries))
			"Mimicked_Device":
				pass
			"3DS_Certificate", "Wii_U_Certificate":
				pass
			"Tint":
				get_node(node).set_pick_color(config.get_value("Globals", entries))

func Defaults():
	for values in globals:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Globals/"+values)
		DaBa.settings.set_value("Globals", values, settingvalue)
	DaBa.settings.set_value("Globals", "Network", 
	ProjectSettings.get_setting("MiiTraverse/Globals/Fallback_Network"))

func Globalset(settingname, value):
	config.set_value("Globals", settingname, value)
	config.save(setpath)

func _on_cache_toggled(button_pressed):
	Globalset("OfflineCache", button_pressed)

func _on_set_reset_pressed():
	Defaults()

func _on_debug_mode_toggled(button_pressed):
	Globalset("DebugMode", button_pressed)

func _on_client_spoof_item_selected(index):
	index = index+1
	Globalset("Mimicked_Device", index)

func _on_default_network_item_selected(index):
	Globalset("Network", Network.networkarray.get(index))

func _on_picker_color_changed(color):
	tempcolor = color

func _on_override_colors_toggled(button_pressed):
	Globalset("OverrideTints", button_pressed)

func _on_picker_popup_closed():
	Globalset("Tint", tempcolor)

func _on_add_profile_pressed():
	pass # Replace with function body.
