extends XMLParser
class_name MiiverseParser

var triggertoggle:bool = false
var key: String
var value: String
var dataArray: Array[Dictionary]
var depthref: int = 0 #A reference to how nested we are in the dataArray

var version:int
var request_name:StringName
var has_error:bool

var parser_error:ParseErrors

enum ParseErrors {
	#You didn't load a buffer
	PARSE_NO_BUFFER,
	#has_error != 0
	PARSE_HAS_ERROR,
	#version is not expected int (1)
	PARSE_BAD_VERSION,
	#A parse on a page was attempted with the wrong function, eg. a community parse on a post page
	PARSE_PAGE_MISMATCH,
}


func _init(raw:PackedByteArray = []):
	open_buffer(raw)
	parse_for_error()

#TriggerNode is the node parent of the child data you want out of the XML, such as `community`
# or `post` from a Miiverse XML
func ConvertXML(raw: PackedByteArray, TriggerNode: StringName) -> Array[Dictionary]:
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

func parse_for_error():
	while read() != ERR_FILE_EOF:
		var checkdata:int = get_node_type()
		print(checkdata)

func parse_for_communities():
	if request_name != &"communities":
		parser_error = ParseErrors.PARSE_PAGE_MISMATCH

func parse_for_community():
	var nodetype:XMLParser.NodeType
	var nodename:StringName
	var nodevalue:String
	var community:CommRes = CommRes.new()
	var reading:bool = true
	while reading:
		read()
		nodetype = get_node_type()
		match nodetype:
			XMLParser.NODE_NONE:
				print("XML node didn't load properly")
			XMLParser.NODE_ELEMENT:
				nodename = get_node_name()
			XMLParser.NODE_ELEMENT_END:
				if get_node_name() == "community":
					reading = false
					continue
				var vartype:int = typeof(community.get(nodename))
				#0 means it is null, which shouldn't be true on found values because typecasting
				if vartype != 0:
					match vartype:
						TYPE_INT:
							community.set(nodename, nodevalue.to_int())
						TYPE_BOOL:
							community.set(nodename, bool(nodevalue.to_int()))
						TYPE_STRING:
							community.set(nodename, nodevalue)
				else:
					print("Value ", nodename ," in XML is not found in CommRes class")
			XMLParser.NODE_TEXT:
				nodevalue = get_node_data()
	return community

func parse_for_post():
	pass

func parse_for_posts():
	pass

func parse_for_topics():
	pass

func parse_for_people():
	pass
