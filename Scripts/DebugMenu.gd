extends HBoxContainer

func _ready():
	var config = ConfigFile.new()
	config.load("user://settings.ini")
	if config.get_value("Settings", "Debug"):
		show()
	else:
		hide()


func _on_button_pressed():
	Network.InitialConnect()

func _on_button_2_pressed():
	Network.PageRequest(Network.allcommunities)

func _on_button_3_pressed():
	database.XMLfileprocess("user://communities.xml")

func _on_button_4_pressed():
	#Network.PageRequest(Network.communitypage)
	print(database.parampackmaker())

func _on_button_5_pressed():
	pass
