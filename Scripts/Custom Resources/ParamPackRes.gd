extends Resource
class_name ParamPackRes



@export var title_id: String
@export var access_key: String
@export var platform_id: String
@export var region_id: String
@export var language_id: String
@export var country_id: String
@export var area_id: String
@export var network_restriction: String
@export var friend_restriction: String
@export var rating_restriction: String
@export var rating_organization: String
@export var transferable_id: String
@export var tz_name: String
@export var utc_offset: String

#This will take all the param pack info set and assemble (duh) it into a ParamPack
func Assemble():
	var outstring: String
	
