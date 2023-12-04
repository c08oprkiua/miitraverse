extends Resource
class_name CommRes

#Based on https://github.com/PretendoNetwork/juxtaposition-ui/blob/main/src/models/communities.js

@export_group("API Data")
@export var app_data: String
@export var name: String
@export var description: String
@export var icon: String
@export var icon_3ds: String
@export var pid: int
@export var is_user_community: String

#these might just be extra bits that Juxt specifically returns
@export_group("Extras")
@export var platform_id: int
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

func ProcessIcon(b64raw):
	if b64raw == null:
		return
	var de64d = Marshalls.base64_to_raw(b64raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var de64d2 = de64d.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(de64d2)
	return ImageTexture.create_from_image(painting)

#This takes all the user-visible data and dumps it in a big string file, so that the Search func
#can look through it when searching
func PlainTextDump():
	pass
