extends HBoxContainer
var config = ConfigFile.new()


func _ready():
	config.load("user://settings.ini")
	if config.get_value("Globals", "Debug"):
		show()
	else:
		hide()


func _on_button_pressed():
	Satellite.emit_signal("SwapNetworks", 0)

func _on_button_2_pressed():
	Network.ThreadManager("Communities")

func _on_button_3_pressed():
	OfflineCacheLoad()

func OfflineCacheLoad():
	var CurrentNetwork = Network.currenthost
	DaBa.CommunityListXML(DaBa.communities, "Communities")

func _on_button_4_pressed():
	print(DaBa.parampackmaker())

func _on_button_5_pressed():
	pass
