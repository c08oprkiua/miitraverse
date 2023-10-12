extends HBoxContainer
var config = DaBa.settings

func _ready():
	#config.load("user://settings.ini")
	if config.get_value("Globals", "DebugMode"):
		show()
	else:
		hide()

func _on_button_pressed():
	Satellite.emit_signal("SwapNetworks", 0)

func _on_button_2_pressed():
	Network.FetchManager("Communities")

func _on_button_3_pressed():
	var xml = XMLtoJSON.new()
	xml.ConvertXML(null, "Communities")

func _on_button_4_pressed():
	Satellite.emit_signal("DebugFunc")

func _on_button_5_pressed():
	pass
