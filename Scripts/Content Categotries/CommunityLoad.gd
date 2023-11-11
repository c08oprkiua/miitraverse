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

func CreateCommunities():
	var xml: XMLParser = XMLParser.new()
	var data: PackedByteArray = DaBa.ContentCheck(3, "communities.xml") #3 is a test value
	if data.is_empty():
		print("No data")
		return
	xml.open_buffer(data)
	var CommunityData: CommRes = CommRes.new()
	var stringtionary: Dictionary
	var entry = 0
	var commtoggle: bool
	var itname: String
	var information: String
	
	while xml.read() != ERR_FILE_EOF:
		var checkdata: int = xml.get_node_type()
		match checkdata:
			XMLParser.NODE_ELEMENT:
				var nodename:String = xml.get_node_name()
				#This node name tells the function that it's gotten to the 
				#relevant data, and starts a dictionary for it
				if nodename == TriggerNode:
					
					stringtionary[entry] = {}
					commtoggle = true
				#This enters a key into the aforemtioned dictionary
				else: 
					itname = nodename
					if xml.is_empty():
						print("is null")
			XMLParser.NODE_ELEMENT_END:
				if commtoggle:
					#I feel like something was gonna go here but idr what
					stringtionary[entry][itname] = information
				if xml.get_node_name() == TriggerNode:
					entry = entry + 1 
					commtoggle = false
			XMLParser.NODE_TEXT:
				if xml.is_empty():
					information = ""
				else:
					information = xml.get_node_data()
			XMLParser.NODE_COMMENT:
				pass
			XMLParser.NODE_CDATA:
				pass
			XMLParser.NODE_UNKNOWN:
				pass
