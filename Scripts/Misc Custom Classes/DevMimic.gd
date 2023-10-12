extends OptionButton
class_name DeviceButton


const devices = {
	"Wii U": 0,
	"3DS": 1,
}

func _ready():
	for keys in devices.keys():
		add_item(keys, devices.get(keys))
	#select(DaBa.settings.get_value("Globals", "Spoof")-1)
