extends Resource
class_name ParamPackRes


#title IDs are usually hex encoded, but in a parampack, they're base10 encoded
@export var title_id: String: 
	set(val): 
		title_id = String.num(val.hex_to_int())
	get:
		
		return title_id

@export var access_key: int = 0 #No key
@export var platform_id:ResEnums.Platform_ID = ResEnums.Platform_ID.WiiU
@export var region_id: int 
@export var language_id: int
@export var country_id: int
@export var area_id: int
@export var network_restriction: int = 0 #No restrictions
@export var friend_restriction: int = 0 #No restrictions
@export var rating_restriction: int = 17 #Mature rating?
@export var rating_organization: int = 1 #ESRB?
@export var transferable_id: String = "whatsatransferableid"
@export var tz_name: String
@export var utc_offset: int 

const ParamPackContents: Array[String] = [
	"title_id",
	"access_key",
	"platform_id",
	"region_id",
	"language_id",
	"country_id",
	"area_id",
	"network_restriction",
	"friend_restriction",
	"rating_restriction",
	"rating_organization",
	"transferable_id",
	"tz_name",
	"utc_offset",
]

#This will take all the param pack info set and assemble (duh) it into a ParamPack
func assemble() -> String:
	var outstring:String
	var key:String 
	var value
	for entries in ParamPackContents:
		key = entries
		value = get(entries)
		if not typeof(value) == TYPE_STRING:
			value = var_to_str(value)
		if outstring.is_empty():
			outstring = ("\\"+key+"\\"+String(value))
		else: 
			outstring = outstring + ("\\"+key+"\\"+value)
	var encoded: String = Marshalls.utf8_to_base64(outstring)
	return encoded
