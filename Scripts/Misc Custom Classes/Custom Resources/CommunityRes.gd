extends Resource
class_name CommRes

#Based on https://github.com/PretendoNetwork/juxtaposition-ui/blob/main/src/models/communities.js

@export var platform_id: int
@export var name: String
@export var description: String
@export var open: bool
@export var allows_comments: bool
@export var type: int
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
@export var app_data: String

#This takes all the user-visible data and dumps it in a big string file, so that the Search func
#can look through it when searching
func PlainTextDump():
	pass
