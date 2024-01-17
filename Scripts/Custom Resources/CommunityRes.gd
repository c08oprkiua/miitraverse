extends OliveRes
class_name CommRes

#Based on https://github.com/PretendoNetwork/juxtaposition-ui/blob/main/src/models/communities.js

enum community_type {
	Main,
	Sub,
	Announcement,
	Private
}

@export_group("API Data")
@export var app_data: String
@export var name: String
@export var description: String
@export var icon: String
@export var icon_3ds: String
@export var pid: int
@export var is_user_community: bool

#these might just be extra bits that Juxt specifically returns
@export_group("Extras")
@export var platform_id: ResEnums.Platform_ID
@export var open: bool
@export var allows_comments: bool
@export var type:community_type
@export var parent: String
@export var admins: Array[int] #?
@export var created_at: String #Date in js
@export var empathy_count: int
@export var followers: int
@export var has_shop_page: int
@export var title_ids: Array[String]
@export var title_id: String
@export var community_id: String
@export var olive_community_id: String
@export var is_recommended: int

#Turns the icon/icon3DS B64 into a TGA
func ProcessIcon(b64raw:String):
	if b64raw == "":
		return
	var de64d:PackedByteArray = Marshalls.base64_to_raw(b64raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of the icon is
	var de64d2:PackedByteArray = de64d.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(de64d2)
	return ImageTexture.create_from_image(painting)

#This takes all the user-visible data and dumps it in a big string file, so that the Search func
#can look through it when searching
func PlainTextDump():
	pass

#Constructs a CommRes from a raw XML representation of the community,
#Which is cut from the overall XML response with another function
func CommRes(rawxml:PackedByteArray):
	var xml:XMLParser = XMLParser.new()
	xml.open_buffer(rawxml)
	var nodetype:XMLParser.NodeType
	var nodename:StringName
	var nodevalue:String
	var writeval
	while xml.read() != ERR_FILE_EOF:
		nodetype = xml.get_node_type()
		match nodetype:
			XMLParser.NODE_NONE:
				print("XML node didn't load properly")
			XMLParser.NODE_ELEMENT:
				nodename = xml.get_node_name()
			XMLParser.NODE_ELEMENT_END:
				if get(nodename) == 0:
					match typeof(get(nodename)):
						TYPE_INT:
							set(nodename, nodevalue.to_int())
						TYPE_BOOL:
							set(nodename, bool(nodevalue.to_int()))
						TYPE_STRING:
							set(nodename, nodevalue)
				else:
					print("Value ", nodename ," in XML is not found in CommRes class")
			XMLParser.NODE_TEXT:
				nodevalue = xml.get_node_data()
