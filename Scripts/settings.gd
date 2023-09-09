extends VBoxContainer

var config = ConfigFile.new()

#Key should match the desired setting in settings.ini,
#Value has to match a UNIQUE node name in the settings tree
var buttonsetindex = {
	"OfflineCache": "Cache",
	"Spoof": "Spoof",
	"Debug": "DebugMode",
}

func _ready():
	config.load("user://settings.ini")
	ButtonsSet()

func ButtonsSet():
	for entries in config.get_section_keys("Settings"):
		if buttonsetindex.has(entries):
			var anode = get_node(buttonsetindex.get(entries))
			anode.set_pressed(config.get_value("Settings", entries))

func Defaults():
	pass

func _on_cache_toggled(button_pressed):
	config.set_value("Settings", "OfflineCache", button_pressed)

func Globalset(name, value):
	config.set_value("Settings", name, value)
	config.save("user://settings.ini")

func _on_scaler_value_changed(value):
	Globalset("UIScale", value)
	ProjectSettings.set("display/window/stretch/scale", value)

func _on_spoof_toggled(button_pressed):
	Globalset("Spoof", button_pressed)

func _on_set_reset_pressed():
	pass # Replace with function body.

func _on_debug_mode_toggled(button_pressed):
	Globalset("Debug", button_pressed)

func _on_client_spoof_item_selected(index):
	pass # Replace with function body.

func _on_default_network_item_selected(index):
	pass # Replace with function body.
