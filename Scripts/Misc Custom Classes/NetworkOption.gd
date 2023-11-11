extends OptionButton
#This is implemented as a custom class so I can copy-paste it wherever (namely
#settings) and have it automatically (re)load all the networks options
class_name NetworkOption

var settings: GlobSet
@export var IsInOptions: bool = false

func _ready():
	settings = DaBa.SettingsCheck()
	Satellite.connect("RefreshNetworks", NetworkIndexLoad)
	if not IsInOptions:
		connect("item_selected", _on_item_selected)
	NetworkIndexLoad()
	select(DaBa.ProfileArray.find(settings.DefaultNetwork))

func NetworkIndexLoad():
	clear()
	for networks in DaBa.ProfileArray:
		var res: Profile = DaBa.ProfileCheck(networks)
		add_item(res.name)

func _on_item_selected(index):
	DaBa.CurrentProfile = DaBa.ProfileArray[index]
	Satellite.emit_signal("SwapNetworks", DaBa.ProfileArray[index])
