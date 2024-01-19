extends OptionButton
#This is implemented as a custom class so I can copy-paste it wherever (namely
# settings) and have it automatically (re)load all the networks options
class_name NetworkOption

static var settings: GlobalSettingRes
@export var IsInOptions: bool = false

static func _static_init():
	settings = DaBa.SettingsCheck()

func _ready():
	Satellite.connect("RefreshNetworks", NetworkIndexLoad)
	if not IsInOptions:
		connect("item_selected", _on_item_selected)
	NetworkIndexLoad()
	select(DaBa.ProfileArray.find(settings.DefaultNetwork))

func NetworkIndexLoad():
	clear()
	var res: ProfileRes
	for networks in DaBa.ProfileArray:
		res = DaBa.ProfileCheck(networks)
		add_item(res.name)

func _on_item_selected(index):
	DaBa.CurrentProfile = DaBa.ProfileArray[index]
	Satellite.emit_signal("SwapNetworks", DaBa.ProfileArray[index])
