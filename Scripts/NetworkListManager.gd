extends OptionButton
#This is implemented as a custom class so I can copy-paste it wherever (namely
#settings) and have it automatically (re)load all the networks options
class_name  NetworkOption


@export var IsInOptions: bool = false

var folder = DirAccess
var config = ConfigFile.new()
var indexnum = 0

var networkarray = {}

func _ready():
	config.load("user://settings.ini")
	if not IsInOptions:
		Satellite.connect("RefreshNetworks", NetworkIndexLoad)
		Satellite.connect("SwapNetworks", select)
		connect("item_selected", _on_item_selected)
	NetworkIndexLoad()

func NetworkIndexLoad():
	for networks in config.get_section_keys("Networks"):
		add_item(networks)
		networkarray[indexnum] = networks
		indexnum += 1
		if not DirAccess.dir_exists_absolute("user://"+networks):
			DirAccess.make_dir_absolute("user://"+networks)
		#I want this to create a folder for every network, named the network's name
		#This will be where the XMLs for that network download to

func _on_item_selected(index):
	Satellite.emit_signal("SwapNetworks", index)
	config.set_value("Settings", "Network", networkarray.get(index))
	config.save("user://settings.ini")
