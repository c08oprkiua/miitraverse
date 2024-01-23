extends OptionButton
#This is implemented as a custom class so I can copy-paste it wherever (namely
# settings) and have it automatically (re)load all the networks options
class_name NetworkOption

static var profiles:Array[String]
@export var IsInOptions: bool = false

static func _static_init():
	Satellite.connect("RefreshNetworks", NetworkOption.NetworkIndexLoad)

static var holup:Mutex = Mutex.new()

static func NetworkIndexLoad():
	holup.lock()
	profiles.clear()
	var res: ProfileRes
	for networks in DaBa.ProfileArray:
		res = DaBa.ProfileCheck(networks)
		profiles.append(res.name)
	holup.unlock()

var current:int

func _ready():
	if not IsInOptions:
		connect("item_selected", _on_item_selected)
	Satellite.connect("RefreshNetworks", loadprofiles)
	NetworkIndexLoad()
	current = DaBa.global_settings.DefaultNetwork

func loadprofiles():
	holup.lock()
	clear()
	for networks in profiles:
		add_item(networks)
	if current <= profiles.size():
		select(current)
	holup.unlock()

func _on_item_selected(index):
	DaBa.CurrentProfile = DaBa.ProfileArray[index]
	Satellite.emit_signal("SwapNetworks", DaBa.ProfileArray[index])
	current = selected
