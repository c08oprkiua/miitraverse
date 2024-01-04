extends Resource
class_name PostRes

#Heavily based on 
#https://github.com/PretendoNetwork/miiverse-api/blob/main/src/types/miiverse/post.ts
#among other sources

@export_group("IDs")
@export var id: String #This is permanent; it cannot be overwirrten by other posts
@export var title_id: String
@export var pid: int
@export var platform_id: int
@export var region_id: int
@export var language_id: int
@export var community_id: String
@export var country_id: int

@export_group("Post Data")
@export var app_data: String
@export var screen_name: String
@export var body: String #Actual "text" of the post
@export var created_at: String
@export var feeling_id: int
@export var is_spoiler: bool
@export var empathy_count: int
@export var yeahs: int
@export var reply_count: int
@export var is_autopost: int
@export var is_community_private_autopost: int

@export_group("Meta Data")
@export var is_app_jumpable: bool
@export var verified: bool
@export var message_to_pid: String
@export var parent: String 
@export var search_key: String
@export var number:int #idk what this does

@export_group("Topic Tag Data")
@export var topic_tag: Dictionary
#These are the values in the dictionary
@export var topic_tag_name: String
@export var topic_tag_title_id: String

@export_group("Painting Data")
@export var painting: Dictionary
#These are the values in the dictionary
@export var painting_format: String
@export var painting_content: String #Tfw Base64
@export var painting_size: int
@export var painting_url: String

@export_group("Screenshot Data")
#These two might not exist
@export var screenshot: String
@export var screenshot_length: int
#Based on the Juxt API
@export var screenshot_size: int
@export var screenshot_url: String

@export_group("Mii Data")
@export var mii: String #Base64 encoded Mii Data
@export var mii_face_url: String

@export_group("Moderation Stats")
#These are special stats only made visible to non-admins with the API. USE WITH CARE
@export var removed: bool
@export var removed_reason: String
@export var removed_by: int
@export var removed_at: String #Date


func PaintingToImage():
	var paintingbuffer: PackedByteArray = Marshalls.base64_to_raw(painting_content)
	paintingbuffer.decompress(painting_size, FileAccess.COMPRESSION_GZIP)
	var painting: Image = Image.new()
	painting.load_tga_from_buffer(paintingbuffer)
	return painting
#Images can be saved to whichever format you want by calling the .save_(format) func, so
