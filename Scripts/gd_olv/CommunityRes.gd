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
#@export var app_data: String
@export var name: String
@export var description: String
@export var icon: String
@export var icon_3ds: String
@export var pid: int
@export var is_user_community: bool

#these might just be extra bits that Juxt specifically returns
@export_group("Extras")
@export var platform_id: Platform_ID
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

func icon_as_image(wiiu_icon:bool = true) -> Image:
	var de64d:PackedByteArray
	if wiiu_icon:
		de64d = Marshalls.base64_to_raw(icon)
	else:
		de64d = Marshalls.base64_to_raw(icon_3ds)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of the icon is
	var de64d2:PackedByteArray = de64d.decompress_dynamic(10000000, 3)
	var img:Image = Image.new()
	img.load_tga_from_buffer(de64d2)
	return img

#This takes all the user-visible data and dumps it in a big string file, so that the Search func
#can look through it when searching
func PlainTextDump():
	pass
