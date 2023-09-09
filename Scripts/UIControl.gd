extends Control

var Config = ConfigFile.new()
var experiment = true

const tabnames = {
	"Home": "VBoxContainer/MainUI/CommunityList",
	"Communities": "VBoxContainer/MainUI/CommunityList",
	"Settings": "VBoxContainer/MainUI/Settings",
}

var itname
var information
var commtoggle

func _ready():
	Network.InitialConnect()
	Config.load("user://settings.ini")
	createsettings()
	SwitchTabs("Home", true)

func createsettings():
	if not Config.has_section("Networks"):
		Config.set_value("Networks", "NoNameVerse", "olvapi.nonamegiven.xyz")
	Config.set_value("Settings", "Network", "NoNameVerse")
	Config.set_value("Settings", "OfflineCache", true)
	Config.save("user://settings.ini")

func SwitchTabs(tabnow, active):
	for tabs in tabnames.keys():
			get_node(tabnames.get(tabs)).hide()
	if active:
		get_node(tabnames.get(tabnow)).show()
	else:
		get_node(tabnames.get("Home")).show()
	

func _on_communities_toggled(button_pressed):
	SwitchTabs("Communities", button_pressed)

func _on_home_toggled(button_pressed):
	SwitchTabs("Home", button_pressed)

func _on_messages_toggled(button_pressed):
	SwitchTabs("Settings", button_pressed)

func _on_notifications_toggled(button_pressed):
	SwitchTabs("Settings", button_pressed)

func _on_settings_toggled(button_pressed):
	SwitchTabs("Settings", button_pressed)

func _on_search_toggled(button_pressed):
	pass # Replace with function body.
