extends OptionButton
#This is implemented as a custom class so I can copy-paste it wherever (namely
#settings) and have it automatically (re)load all the networks options
class_name  NetworkOption

@export var IsInOptions: bool = false

var indexnum = 0

func _ready():
	DaBa.settings.load("user://settings.ini")
	Satellite.connect("RefreshNetworks", NetworkIndexLoad)
	if not IsInOptions:
		connect("item_selected", _on_item_selected)
	NetworkIndexLoad()

func NetworkIndexLoad():
	for networks in Network.networkarray.keys():
		add_item(Network.networkarray.get(networks))

func _on_item_selected(index):
	Network.currenthost = Network.networkarray.get(index)
	Satellite.emit_signal("SwapNetworks", index)
