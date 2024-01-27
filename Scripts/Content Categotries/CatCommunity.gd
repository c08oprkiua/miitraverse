extends CatFlowContainer

func _ready():
	connect("WhenActive", ActivateConnection)
#	connect("WhenInactive", DeactivateConnection)

func ActivateConnection():
	if API_Callable.is_empty():
		return

func load_communities():
	var parser:MiiverseParser = MiiverseParser.new()
	var response:PackedByteArray = CheckDataSource()
	API.FetchManager("get_communities")
	parser.ConvertXML(response, "community")
	var parsed_data:Array[Dictionary] 
