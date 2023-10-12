extends VBoxContainer

var ThisProfile

const profile = [
	"Name",
	"URL",
	"OfflineCache",
	"Mimicked_Device",
	"Tint",
	"UseUniqueTint",
]

const nodeindex = {
	"dropdown": {
		"Mimicked_Device": "SpoofClients/ClientSpoof",
	},
	"binary": {
		"OfflineCache": "Cache",
	},
	"detailed": {
		"Tint": "DefaultTint/Picker",
	}
}

func _ready():
	Satellite.connect("NewProfile", InitNewProfile, 4)
	Satellite.connect("LoadProfile", GrabInfo, 4)
	await Satellite.LoadProfile #Might cause problems
	print("Await passed")
	if not DaBa.settings.has_section(ThisProfile):
		InitNewProfile(ThisProfile)

func GrabInfo(index):
	ThisProfile = Network.networkarray.get(index)
	$"BubbleName".text = ThisProfile
	ButtonsSet()
	Satellite.disconnect("NewProfile", InitNewProfile)

func Defaults():
	for entries in profile:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Verse/"+entries)
		DaBa.settings.set_value(name, entries, settingvalue)

func InitNewProfile(name):
	DirAccess.make_dir_absolute("user://"+name)
	for entries in profile:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Verse/"+entries)
		DaBa.settings.set_value(name, entries, settingvalue)

#This is the magic function that sets all the button states in settings
func ButtonsSet():
	for categories in DaBa.settings.get_section_keys(ThisProfile):
		print(categories)
		match categories:
			"binary":
				for keys in nodeindex[categories].keys():
					var anode = get_node(nodeindex[categories].get(keys))
					anode.set_pressed(DaBa.settings.get_value(ThisProfile, keys))
			"detailed":
				pass
			"dropdown":
				pass

func ProfileSet(name, value):
	DaBa.settings.set_value(ThisProfile, name, value)
	DaBa.settings.save(DaBa.setpath)

func _on_cache_toggled(button_pressed):
	ProfileSet("OfflineCache", button_pressed)

func _on_set_reset_pressed():
	Defaults()

func _on_client_spoof_item_selected(index):
	index = index+1
	ProfileSet("Spoof", index)

func _on_picker_color_changed(color):
	ProfileSet("Tint", color)
