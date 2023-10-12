extends VBoxContainer

var tempcolor
var ThisProfile: 
	set(ProfVal):
		ThisProfile = ProfVal
		emit_signal("ProfSet")
signal ProfSet

const profile = [
	"OfflineCache",
	"Mimicked_Device",
	"Tint",
	"UseUniqueTint",
]

const nodeindex = {
	"Mimicked_Device": "SpoofClients/ClientSpoof",
	"OfflineCache": "Cache",
	"Tint": "DefaultTint/Picker",
	"UseUniqueTint": "Use Tint"
}

func _ready():
	Satellite.connect("NewProfile", InitNewProfile, 4)
	Satellite.connect("LoadProfile", GrabInfo, 4)
	await ProfSet
	print("Await passed")
	if not DaBa.settings.has_section(ThisProfile):
		InitNewProfile(ThisProfile)
	ButtonsSet()

func GrabInfo(index):
	ThisProfile = Network.networkarray.get(index)
	$"BubbleName".text = ThisProfile
	Satellite.disconnect("NewProfile", InitNewProfile)

func Defaults():
	for entries in profile:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Verse/"+entries)
		DaBa.settings.set_value(ThisProfile, entries, settingvalue)

func InitNewProfile(newname):
	ThisProfile = newname
	DirAccess.make_dir_absolute("user://"+newname)
	for entries in profile:
		var settingvalue = ProjectSettings.get_setting("MiiTraverse/Verse/"+entries)
		DaBa.settings.set_value(newname, entries, settingvalue)
		ProfileSet(entries, settingvalue)

#This is the magic function that sets all the button states in settings
func ButtonsSet():
	for entries in DaBa.settings.get_section_keys(ThisProfile):
		var node = nodeindex.get(entries)
		match entries:
			"DebugMode", "OfflineCache":
				get_node(node).set_pressed(DaBa.settings.get_value(ThisProfile, entries))
			"Mimicked_Device":
				pass
			"3DS_Certificate", "Wii_U_Certificate":
				pass
			"Tint":
				get_node(node).set_pick_color(DaBa.settings.get_value(ThisProfile, entries))

func ProfileSet(settingname, value):
	DaBa.settings.set_value(ThisProfile, settingname, value)
	DaBa.settings.save(DaBa.setpath)

func _on_cache_toggled(button_pressed):
	ProfileSet("OfflineCache", button_pressed)

func _on_client_spoof_item_selected(index):
	index = index+1
	ProfileSet("Mimicked_Device", index)

func _on_picker_color_changed(color):
	tempcolor = color

func _on_picker_popup_closed():
	ProfileSet("Tint", tempcolor)

func _on_use_tint_toggled(button_pressed):
	ProfileSet("UseUniqueTint", button_pressed)

func _on_set_reset_pressed():
	Defaults()

func _on_delete_me_pressed():
	DaBa.settings.erase_section(ThisProfile)
	DaBa.settings.erase_section_key("Networks", ThisProfile)
	DaBa.settings.save(DaBa.setpath)
	queue_free()
