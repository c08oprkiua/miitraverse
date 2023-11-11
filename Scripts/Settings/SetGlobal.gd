extends VBoxContainer

#Partly just here so I am 200% sure I don't typo, lol

var indexnum = 0
var tempcolor

var sets: GlobSet

#Key should match the desired setting in settings.ini,
#Value has to match a UNIQUE node name in the settings tree
const nodeindex = {
	"Mimicked_Device": "SpoofClients/ClientSpoof",
	"Network": "DefaultNetwork/DefaultNetwork",
	"OfflineCache": "Cache",

	"Tint": "DefaultTint/Picker",
	"3DS_Certificate": "3DSCert/LineEdit", #The console cert necessary to fully mimic a 3DS
	"Wii_U_Certificate": "WiiUCert/LineEdit", #The console cert necessary to fully mimic a Wii U 
	"OverrideTints": "OverrideColors",
}

const globals = [
	"OfflineCache",
	"3DS_Certificate",
	"Wii_U_Certificate",
	"Tint",
]

func _ready():
	sets = DaBa.SettingsCheck()
	ButtonsSet()

#This is the magic function that sets all the button states in settings
func ButtonsSet():
	for entries in nodeindex.keys():
		var node = nodeindex.get(entries)
		var globval = sets.get(entries)
		match typeof(globval):
			TYPE_BOOL:
				get_node(node).set_pressed(globval)
			TYPE_INT:
				get_node(node).select(globval)
			TYPE_STRING:
				get_node(node).text = globval
			TYPE_COLOR:
				get_node(node).set_pick_color(globval)
		DaBa.set(entries, sets.get(entries))

func Globalset(settingname: StringName, value):
	DaBa.set(settingname, value)
	sets.set(settingname, value)
	ResourceSaver.save(sets, GlobSet.savepath)

func _on_cache_toggled(button_pressed):
	Globalset("OfflineCache", button_pressed)

func _on_set_reset_pressed():
	sets.Defaults()

func _on_default_network_item_selected(index):
	Globalset("DefaultNetwork", DaBa.ProfileArray[index])

func _on_default_network_item_focused(index):
	Globalset("DefaultNetwork", DaBa.ProfileArray[index])

func _on_picker_color_changed(color):
	tempcolor = color

func _on_override_colors_toggled(button_pressed):
	Globalset("OverrideTints", button_pressed)

func _on_picker_popup_closed():
	Globalset("Tint", tempcolor)

func _on_add_profile_pressed():
	#var profpopup: PackedScene = load("res://Scenes/name_dialogue.tscn")
	#Satellite.emit_signal("NewPopUp", profpopup)
	var newindex:int = 1
	while DaBa.ProfileArray.has(newindex):
		newindex += 1
	Satellite.emit_signal("NewProfile", newindex)
	Satellite.emit_signal("RefreshNetworks")



