extends CatFlowContainer

func _ready():
	connect("WhenActive", ActivateConnection)
#	connect("WhenInactive", DeactivateConnection)

func ActivateConnection():
	if URL.is_empty():
		return

#	Network.connect("Done", ProcessReadData, 4)
#	Satellite.emit_signal("NetFetch", ContentName)

#func DeactivateConnection():
#	if Network.is_connected("Done", ProceedLoadList):
#		Network.disconnect("Done", ProceedLoadList)
