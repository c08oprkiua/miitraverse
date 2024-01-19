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

func load_communities():
	var parser:MiiverseParser = MiiverseParser.new()
	var response:PackedByteArray = []
	API.FetchManager("get_communities")
	parser.ConvertXML(response, "community")
