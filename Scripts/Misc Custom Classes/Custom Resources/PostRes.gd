extends Resource
class_name PostRes

@export_group("IDs")
@export var id: String #This is permanent; it cannot be overwirrten by other posts
@export var title_id: String
@export var pid: int
@export var platform_id: int
@export var region_id: int
@export var country_id: int
@export var language_id: int
@export var community_id: String

@export_group("Public Data")
@export var screen_name: String
@export var body: String #Actual "text" of the post
@export var created_at: String
@export var feeling_id: int
@export var is_spoiler: int
@export var empathy_count: int
@export var yeahs: int
@export var reply_count: int

@export var is_autopost: int
@export var is_community_private_autopost: int

@export_group("Meta Data")
@export var app_data: String
@export var is_app_jumpable: int
@export var verified: bool
@export var message_to_pid: String
@export var parent: String 
@export var search_key: String
@export var topic_tag: String

@export_group("Painting data")
@export var painting: Dictionary = {
	"format": "",
	"content": "",
	"size": "",
	"url": ""
}
@export var format: String
@export var content: String #Tfw Base64
@export var size: int
@export var url: String

@export_group("Screenshot Data")
@export var screenshot: String
@export var screenshot_length: int

@export_group("Mii Data")
@export var mii: String #Base64 encoded Mii Data
@export var mii_face_url: String

@export_group("Moderation Stats")
@export var removed: bool
@export var removed_reason: String
@export var removed_by: int
@export var removed_at: String #Date


func PaintingToImage():
	var paintingbuffer: PackedByteArray = Marshalls.base64_to_raw(content)
	paintingbuffer.decompress(size, FileAccess.COMPRESSION_GZIP)
	var painting: Image = Image.new()
	painting.load_tga_from_buffer(paintingbuffer)
	return painting
#Images can be saved to whichever format you want by calling the .save_(format) func, so
