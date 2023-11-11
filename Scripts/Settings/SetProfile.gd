extends VBoxContainer

signal ProfSet

var tempcolor
var profres: Profile = Profile.new()

var profnum: int:
	set(ProfVal):
		profnum = ProfVal
		filepath = ("user://Profile"+String.num(profnum)+"/settings.tres")
		basedir = filepath.get_base_dir()
		emit_signal("ProfSet")

var filepath: String = "user://Profile"+String.num(profnum)+"/settings.tres"
var basedir: String

const nodeindex = {
	"Mimicked_Device": "SpoofClients/ClientSpoof",
	"Region": "More/Region/RegionOpt",
	
	"OfflineCache": "Cache",
	"ShowSpoilers": "Spoilers",
	"UseUniqueTint": "UseTint",
	
	"Tint": "DefaultTint/Picker",
	
	"url": "APIURL/API",
	"name": "ProfileName/ProfName",
	"Username": "Login/Username/Username",
	"Password": "Login/Password/Password",
	"AccountServWiiU": "More/AccountWiiU/AccWiiU",
	"AccountServ3DS": "More/Account3DS/Acc3DS",
	
}

func _ready():
	Satellite.connect("LoadProfile", GrabInfo, 4)
	await ProfSet
	print("Await passed")
	

func GrabInfo(mynumber):
	profnum = mynumber
	if not FileAccess.file_exists(filepath):
		InitNewProfile()
	profres = ResourceLoader.load(filepath) as Profile
	ButtonsSet()

func InitNewProfile():
	DirAccess.make_dir_absolute(basedir)
	profres.Defaults()
	profres.name = "Profile"+String.num(profnum)
	ResourceSaver.save(profres, filepath)

#This is the magic function that sets all the button states in settings
func ButtonsSet():
	$"BubbleName".text = profres.name
	for entries in nodeindex.keys():
		var node = nodeindex.get(entries)
		var setvalue = profres.get(entries)
		#This Just Works:tm: for most settings, other ones can be manually set
		match typeof(setvalue):
			TYPE_BOOL:
				get_node(node).set_pressed(setvalue)
			TYPE_INT:
				get_node(node).select(setvalue)
			TYPE_COLOR:
				get_node(node).set_pick_color(setvalue)
			TYPE_STRING_NAME, TYPE_STRING:
				get_node(node).text = setvalue

func ProfileSet(settingname: StringName, value):
	profres.set(settingname, value)
	ResourceSaver.save(profres, filepath)

#Bools
func _on_cache_toggled(button_pressed):
	ProfileSet("OfflineCache", button_pressed)

func _on_spoilers_toggled(button_pressed):
	ProfileSet("ShowSpoilers", button_pressed)

func _on_use_tint_toggled(button_pressed):
	ProfileSet("UseUniqueTint", button_pressed)

#Indexes
func _on_client_spoof_item_selected(index):
	ProfileSet("Mimicked_Device", index)

func _on_region_opt_item_selected(index):
	ProfileSet("Region", index)

#Color
func _on_picker_color_changed(color):
	tempcolor = color

func _on_picker_popup_closed():
	ProfileSet("Tint", tempcolor)

#Text
func _on_api_text_changed(new_text):
	ProfileSet("url", new_text)

func _on_prof_name_text_changed(new_text):
	$"BubbleName".text = new_text
	ProfileSet("name", new_text)
	Satellite.emit_signal("RefreshNetworks")

func _on_username_text_changed(new_text):
	ProfileSet("Username", new_text)

func _on_password_text_changed(new_text):
	ProfileSet("Password", new_text)

func _on_acc_wii_u_text_changed(new_text):
	ProfileSet("AccountServWiiU", new_text)

func _on_acc_3ds_text_changed(new_text):
	ProfileSet("AccountServ3DS", new_text)

#Special
func _on_set_reset_pressed():
	profres.Defaults()
	ButtonsSet()
	Satellite.emit_signal("RefreshNetworks")
	ResourceSaver.save(profres, filepath)

func _on_delete_me_pressed():
	#Note: Add confirmation popup 
	for files in DirAccess.get_files_at(basedir):
		DirAccess.remove_absolute(basedir+"/"+files)
	DirAccess.remove_absolute(basedir)
	var lookfor = DaBa.ProfileArray.find(profnum)
	DaBa.ProfileArray.remove_at(lookfor)
	Satellite.emit_signal("RefreshNetworks")
	get_parent().emit_signal("DeleteRequest")

#UI view toggles
func _on_show_more_toggled(button_pressed):
	if button_pressed:
		$"More".show()
	else:
		$"More".hide()

func _on_show_login_toggled(button_pressed):
	if button_pressed:
		$"Login".show()
	else:
		$"Login".hide()
