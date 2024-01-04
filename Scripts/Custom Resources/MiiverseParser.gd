extends XMLParser
class_name MiiverseParser

var triggertoggle:bool = false
var key: String
var value: String
var dataArray: Array[Dictionary]
var depthref: int = 0 #A reference to how nested we are in the dataArray

#TriggerNode is the node parent of the child data you want out of the XML, such as `community`
# or `post` from a Miiverse XML
func ConvertXML(raw: PackedByteArray, TriggerNode: StringName):
	dataArray.clear()
	open_buffer(raw)
	var stringtionary: Dictionary = {}
	while read() != ERR_FILE_EOF:
		var checkdata:int = get_node_type()
		match checkdata:
			XMLParser.NODE_ELEMENT:
				var nodename:StringName = get_node_name()
				#This nodename tells the function that it's gotten to the 
				#relevant data, and starts loading it into the Stringtionary
				if nodename == TriggerNode:
					stringtionary.clear()
					triggertoggle = true
				else:
					key = nodename
					if is_empty():
						print("is null")
			XMLParser.NODE_ELEMENT_END:
				if triggertoggle:
					#I feel like something was gonna go here but idr what
					stringtionary[key] = value
				if get_node_name() == TriggerNode:
					var sanitycheck: Dictionary = stringtionary.duplicate(true)
					dataArray.append(sanitycheck)
					triggertoggle = false
			XMLParser.NODE_TEXT:
				if is_empty():
					value = ""
				else:
					value = get_node_data()
			XMLParser.NODE_COMMENT:
				pass
			XMLParser.NODE_CDATA:
				pass
			XMLParser.NODE_UNKNOWN:
				pass
	print("XML processed")
	return dataArray
